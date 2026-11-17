#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
SCRIPT="$ROOT/v2/build/check-build-gates.sh"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/bin" "$tmp/sources"
cat > "$tmp/bin/id" <<'SH'
#!/usr/bin/env bash
printf '1000\n'
SH
chmod +x "$tmp/bin/id"
set +e
output="$(PATH="$tmp/bin:$PATH" DEROX_SOURCE_DIR="$tmp/sources" bash "$SCRIPT" 2>&1)"
status=$?
set -e
[[ "$status" -ne 0 ]] || { echo "FAIL: empty source lock unexpectedly passed" >&2; exit 1; }
grep -q "source lock is empty" <<<"$output" || { printf '%s\n' "$output" >&2; exit 1; }
echo "PASS: empty source lock blocks build readiness"
