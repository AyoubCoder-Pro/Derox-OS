#!/usr/bin/env bash
set -Eeuo pipefail
fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
[[ "$(id -u)" -ne 0 ]] || fail "run as an unprivileged build user, not root"
[[ "$#" -eq 1 ]] || fail "usage: install-init.sh TARGET_INITRAMFS_ROOT"
SRC="$(cd -- "$(dirname -- "$0")" && pwd -P)/init"
[[ -f "$SRC" ]] || fail "init source file is missing"
mkdir -p -- "$1"
TARGET="$(cd -- "$1" && pwd -P)"
[[ "$TARGET" != "/" ]] || fail "target initramfs root must not be /"
install -D -m 0755 "$SRC" "$TARGET/init"
printf 'Installed executable initramfs /init into %s\n' "$TARGET"
