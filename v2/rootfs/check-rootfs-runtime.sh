#!/usr/bin/env bash
set -Eeuo pipefail
fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
[[ "$#" -eq 1 ]] || fail "usage: check-rootfs-runtime.sh TARGET_ROOTFS"
[[ -d "$1" ]] || fail "target rootfs directory does not exist"
ROOTFS="$(cd -- "$1" && pwd -P)"
[[ "$ROOTFS" != "/" ]] || fail "refusing to inspect host root /"
missing=()
require_file() {
  local path="$1"
  [[ -x "$ROOTFS/$path" ]] || missing+=("$path (executable)")
}
require_any_file() {
  local description="$1"; shift
  local found=0 path
  for path in "$@"; do
    if [[ -x "$ROOTFS/$path" ]]; then found=1; break; fi
  done
  (( found )) || missing+=("$description (one of: $*)")
}
require_any_file "systemd init" usr/lib/systemd/systemd lib/systemd/systemd
require_file bin/sh
require_file usr/bin/env
require_any_file "init entry point" sbin/init usr/sbin/init
[[ -s "$ROOTFS/etc/os-release" ]] || missing+=("etc/os-release (non-empty)")
[[ -s "$ROOTFS/etc/fstab" ]] || missing+=("etc/fstab (non-empty)")
[[ -d "$ROOTFS/usr/lib" ]] || missing+=("usr/lib directory")
[[ -d "$ROOTFS/var" ]] || missing+=("var directory")
if (( ${#missing[@]} )); then
  printf 'DEROX rootfs runtime check: FAILED\n' >&2
  printf ' - %s\n' "${missing[@]}" >&2
  exit 1
fi
printf 'DEROX rootfs runtime check: PASS\n'
printf 'Target: %s\n' "$ROOTFS"
printf 'Note: this checks minimum staged runtime files; it does not prove bootability.\n'
