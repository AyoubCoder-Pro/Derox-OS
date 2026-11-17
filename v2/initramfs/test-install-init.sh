#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd -- "$(dirname -- "$0")/../.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/initramfs"
bash "$ROOT/v2/initramfs/install-init.sh" "$TMP/initramfs"
test -x "$TMP/initramfs/init"
grep -q 'DEROX early userspace' "$TMP/initramfs/init"
if bash "$ROOT/v2/initramfs/install-init.sh" / >/dev/null 2>&1; then
  echo "ERROR: installer accepted / as target" >&2
  exit 1
fi
echo "PASS: initramfs init installer tests"
