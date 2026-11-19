#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
SCRIPT="$ROOT/v2/rootfs/create-rootfs-skeleton.sh"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
TARGET="$TMP/target"
mkdir -p "$TARGET"
bash "$SCRIPT" "$TARGET"
for path in etc dev proc sys usr/bin usr/lib var/log home root; do
  [[ -d "$TARGET/$path" ]] || { echo "missing directory: $path" >&2; exit 1; }
done
[[ "$(stat -c '%a' "$TARGET/tmp")" == "1777" ]]
[[ "$(stat -c '%a' "$TARGET/var/tmp")" == "1777" ]]
grep -q 'DEROX_ROOTFS_LAYOUT=1' "$TARGET/usr/lib/derox/rootfs-layout-version"
grep -q '^proc ' "$TARGET/etc/fstab"
printf '# keep-me\n' >> "$TARGET/etc/fstab"
bash "$SCRIPT" "$TARGET" >/dev/null
grep -q '# keep-me' "$TARGET/etc/fstab"
if bash "$SCRIPT" / >/dev/null 2>&1; then echo "ERROR: accepted / as target" >&2; exit 1; fi
echo "PASS: DEROX rootfs skeleton tests"
