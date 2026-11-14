#!/usr/bin/env bash
# Non-invasive host preflight for DEROX OS 2.0.
set -u

if [[ "${1:-}" == "--help" ]]; then
  echo "Usage: bash v2/build/host-check.sh"
  echo "Checks host platform, build tools, memory, and free disk space."
  exit 0
fi

errors=0
warnings=0
required_commands=(
  bash awk sed grep find sort xargs
  gcc g++ ld make m4 bison perl python3
  tar gzip bzip2 xz patch diff
)

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "ERROR: DEROX source builds require a native Linux host."
  errors=$((errors + 1))
fi

machine="$(uname -m 2>/dev/null || true)"
if [[ "$machine" != "x86_64" ]]; then
  echo "ERROR: expected x86_64 host; detected: ${machine:-unknown}"
  errors=$((errors + 1))
else
  echo "OK: host architecture is x86_64"
fi

missing=()
for command_name in "${required_commands[@]}"; do
  if ! command -v "$command_name" >/dev/null 2>&1; then
    missing+=("$command_name")
  fi
done

if (("${#missing[@]}" > 0)); then
  printf 'ERROR: missing required commands: %s\n' "${missing[*]}"
  errors=$((errors + 1))
else
  echo "OK: required build commands are available"
fi

if [[ -r /proc/meminfo ]]; then
  mem_kib="$(awk '/^MemTotal:/ {print $2; exit}' /proc/meminfo)"
  if [[ -n "$mem_kib" ]] && (( mem_kib < 8388608 )); then
    echo "WARNING: less than 8 GiB RAM; a full build may be slow or fail."
    warnings=$((warnings + 1))
  else
    echo "OK: memory is at least 8 GiB (or could not be measured)"
  fi
else
  echo "WARNING: cannot read /proc/meminfo to estimate RAM."
  warnings=$((warnings + 1))
fi

available_kib="$(df -Pk . 2>/dev/null | awk 'NR==2 {print $4}')"
if [[ "$available_kib" =~ ^[0-9]+$ ]] && (( available_kib < 62914560 )); then
  echo "WARNING: less than 60 GiB free in the current filesystem."
  warnings=$((warnings + 1))
elif [[ "$available_kib" =~ ^[0-9]+$ ]]; then
  echo "OK: at least 60 GiB free in the current filesystem"
else
  echo "WARNING: could not measure free disk space."
  warnings=$((warnings + 1))
fi

echo "Preflight summary: $errors error(s), $warnings warning(s)."
if (( errors > 0 )); then
  exit 1
fi
echo "Host preflight passed. This does not mean DEROX itself has been built."
