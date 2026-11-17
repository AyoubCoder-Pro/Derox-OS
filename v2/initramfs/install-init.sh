#!/usr/bin/env bash
set -Eeuo pipefail
fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
[[ "$(id -u)" -ne 0 ]] || fail "run as an unprivileged build user, not root"
[[ "$#" -eq 2 ]] || fail "usage: install-init.sh TARGET_INITRAMFS_ROOT OUTPUT_ROOTFS"
SRC="$(cd -- "$(dirname -- "$0")" && pwd -P)/init"
[[ -f "$SRC" ]] || fail "init source file is missing"
TARGET="$(cd -- "$1" 2>/dev/null && pwd -P)" || fail "target initramfs root does not exist"
mkdir -p -- "$2"
ROOT="$(cd -- "$2" && pwd -P)"
[[ "$ROOT" != "/" ]] || fail "output rootfs must not be /"
install -D -m 0755 "$SRC" "$TARGET/init"
printf 'Installed executable initramfs /init into %s\n' "$TARGET"
