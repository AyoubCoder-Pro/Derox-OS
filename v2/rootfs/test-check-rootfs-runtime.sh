#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
SCRIPT="$ROOT/v2/rootfs/check-rootfs-runtime.sh"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
TARGET="$TMP/rootfs"
mkdir -p "$TARGET/usr/lib/systemd" "$TARGET/bin" "$TARGET/usr/bin" "$TARGET/sbin" "$TARGET/etc" "$TARGET/usr/lib" "$TARGET/var"
for path in usr/lib/systemd/systemd bin/sh usr/bin/env sbin/init; do
  printf '#!/bin/sh\nexit 0\n' > "$TARGET/$path"
  chmod 755 "$TARGET/$path"
done
printf 'NAME=DEROX\n' > "$TARGET/etc/os-release"
printf '# DEROX fstab\n' > "$TARGET/etc/fstab"
bash "$SCRIPT" "$TARGET" >/dev/null
rm "$TARGET/usr/bin/env"
if bash "$SCRIPT" "$TARGET" >/dev/null 2>&1; then
  echo "ERROR: runtime checker accepted missing usr/bin/env" >&2
  exit 1
fi
if bash "$SCRIPT" / >/dev/null 2>&1; then
  echo "ERROR: runtime checker accepted host root /" >&2
  exit 1
fi
echo "PASS: DEROX rootfs runtime checker tests"
