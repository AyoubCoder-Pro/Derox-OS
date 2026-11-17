#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd -- "$(dirname -- "$0")/../.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/rootfs" "$TMP/bin"
printf '#!/bin/sh\nexec /bin/sh\n' > "$TMP/rootfs/init"
chmod 0755 "$TMP/rootfs/init"
cat > "$TMP/bin/cpio" <<'MOCK'
#!/usr/bin/env bash
set -eu
cat >/dev/null
printf '070701DEROX-TEST-NEWC'
MOCK
chmod +x "$TMP/bin/cpio"
PATH="$TMP/bin:$PATH" bash "$ROOT/v2/initramfs/create-initramfs.sh" "$TMP/rootfs" "$TMP/out/derox-initramfs.cpio.gz"
gzip -t "$TMP/out/derox-initramfs.cpio.gz"
gzip -dc "$TMP/out/derox-initramfs.cpio.gz" | grep -q '^070701DEROX-TEST-NEWC$'
if PATH="$TMP/bin:$PATH" bash "$ROOT/v2/initramfs/create-initramfs.sh" "$TMP/rootfs" "$TMP/rootfs/archive.gz" >/dev/null 2>&1; then
  echo "ERROR: output inside rootfs was accepted" >&2
  exit 1
fi
mkdir -p "$TMP/empty"
if PATH="$TMP/bin:$PATH" bash "$ROOT/v2/initramfs/create-initramfs.sh" "$TMP/empty" "$TMP/empty.gz" >/dev/null 2>&1; then
  echo "ERROR: rootfs without /init was accepted" >&2
  exit 1
fi
echo "PASS: initramfs builder tests"
