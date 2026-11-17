#!/usr/bin/env bash
# Install DEROX OS identity files into a target root filesystem only.
set -Eeuo pipefail

usage() {
  echo "Usage: $0 TARGET_ROOTFS" >&2
}

if [[ $# -ne 1 ]]; then
  usage
  exit 2
fi

rootfs=$1
[[ -d "$rootfs" ]] || { echo "ERROR: target rootfs does not exist: $rootfs" >&2; exit 1; }

install -d "$rootfs/etc" "$rootfs/usr/share/derox"
cat > "$rootfs/etc/os-release" <<'EOF'
NAME="DEROX OS"
PRETTY_NAME="DEROX OS 2.0 (Development)"
ID=derox
ID_LIKE=""
VERSION="2.0 Development"
VERSION_ID="2.0"
VERSION_CODENAME=development
HOME_URL="https://ayoubcoder-pro.github.io/Derox-OS/"
DOCUMENTATION_URL="https://github.com/AyoubCoder-Pro/Derox-OS"
SUPPORT_URL="https://github.com/AyoubCoder-Pro/Derox-OS/issues"
BUG_REPORT_URL="https://github.com/AyoubCoder-Pro/Derox-OS/issues"
EOF

cat > "$rootfs/etc/issue" <<'EOF'
DEROX OS 2.0 Development \n \l

This is a development build. Features and hardware support are not final.
EOF

printf '%s\n' 'derox' > "$rootfs/etc/hostname"
cat > "$rootfs/etc/motd" <<'EOF'
Welcome to DEROX OS 2.0 Development.

This system is experimental. Back up important data and report issues at:
https://github.com/AyoubCoder-Pro/Derox-OS/issues
EOF

cat > "$rootfs/usr/share/derox/release-info" <<'EOF'
distribution=DEROX OS
version=2.0
track=development
architecture=x86_64
base=Linux From Scratch
init=systemd
desktop=XFCE (planned)
EOF

echo "DEROX OS identity files installed into $rootfs"
