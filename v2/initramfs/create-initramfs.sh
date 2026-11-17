#!/usr/bin/env bash
set -Eeuo pipefail
fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
[[ "$(id -u)" -ne 0 ]] || fail "run as an unprivileged build user, not root"
[[ "$#" -eq 2 ]] || fail "usage: create-initramfs.sh TARGET_ROOTFS OUTPUT_INITRAMFS"
ROOTFS="$(cd -- "$1" 2>/dev/null && pwd -P)" || fail "target rootfs does not exist"
[[ -f "$ROOTFS/init" && -x "$ROOTFS/init" ]] || fail "target rootfs must contain an executable /init"
mkdir -p -- "$(dirname -- "$2")"
OUT_DIR="$(cd -- "$(dirname -- "$2")" && pwd -P)"
OUT="$OUT_DIR/$(basename -- "$2")"
case "$OUT" in "$ROOTFS"/*) fail "output must be outside the target rootfs";; esac
for tool in find cpio gzip; do
  command -v "$tool" >/dev/null 2>&1 || fail "required command not found: $tool"
done
TMP="$OUT.tmp.$$"
trap 'rm -f -- "$TMP"' EXIT
(
  cd -- "$ROOTFS"
  find . -print0 | cpio --null --create --format=newc --quiet
) | gzip -9 > "$TMP"
[[ -s "$TMP" ]] || fail "initramfs archive is empty"
gzip -t "$TMP" || fail "generated initramfs failed gzip integrity check"
mv -f -- "$TMP" "$OUT"
trap - EXIT
printf 'Initramfs created: %s\n' "$OUT"
printf 'Format: gzip-compressed cpio newc\n'
