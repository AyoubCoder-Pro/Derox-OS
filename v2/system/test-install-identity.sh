#!/usr/bin/env bash
set -Eeuo pipefail
repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
fail() { echo "FAIL: $*" >&2; exit 1; }
mkdir -p "$tmp/rootfs"
bash "$repo_root/v2/system/install-identity.sh" "$tmp/rootfs"
[[ -f "$tmp/rootfs/etc/os-release" ]] || fail "os-release missing"
grep -qx 'ID=derox' "$tmp/rootfs/etc/os-release" || fail "wrong distribution ID"
grep -qx 'VERSION_ID="2.0"' "$tmp/rootfs/etc/os-release" || fail "wrong version"
grep -qx 'derox' "$tmp/rootfs/etc/hostname" || fail "wrong hostname"
grep -q 'experimental' "$tmp/rootfs/etc/motd" || fail "development warning missing"
grep -qx 'base=Linux From Scratch' "$tmp/rootfs/usr/share/derox/release-info" || fail "base metadata missing"
if bash "$repo_root/v2/system/install-identity.sh" "$tmp/missing-root" >/dev/null 2>&1; then
  fail "installer accepted a missing rootfs"
fi
echo "PASS: DEROX identity staging tests"
