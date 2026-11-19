#!/usr/bin/env bash
set -Eeuo pipefail
fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
[[ "$(id -u)" -ne 0 ]] || fail "run as an unprivileged build user, not root"
[[ "$#" -eq 1 ]] || fail "usage: create-rootfs-skeleton.sh TARGET_ROOTFS"
[[ -d "$1" ]] || fail "target rootfs directory must already exist"
ROOTFS="$(cd -- "$1" && pwd -P)"
[[ "$ROOTFS" != "/" ]] || fail "target rootfs must not be /"
dirs=(bin boot dev etc home lib media mnt opt proc root run sbin srv sys tmp usr/bin usr/include usr/lib usr/libexec usr/local/bin usr/local/include usr/local/lib usr/local/sbin usr/local/share usr/sbin usr/share usr/src var/cache var/lib var/local var/lock var/log var/opt var/run var/spool var/tmp)
for dir in "${dirs[@]}"; do install -d "$ROOTFS/$dir"; done
chmod 1777 "$ROOTFS/tmp" "$ROOTFS/var/tmp"
install -d "$ROOTFS/usr/share/derox" "$ROOTFS/usr/lib/derox"
cat > "$ROOTFS/usr/lib/derox/rootfs-layout-version" <<'EOF'
DEROX_ROOTFS_LAYOUT=1
distribution=DEROX OS
release=2.0-development
EOF
if [[ ! -e "$ROOTFS/etc/fstab" ]]; then
cat > "$ROOTFS/etc/fstab" <<'EOF'
# DEROX OS 2.0 - filesystem table template
# The root filesystem entry is supplied by the installer.
proc     /proc   proc     nosuid,noexec,nodev  0 0
sysfs    /sys    sysfs    nosuid,noexec,nodev  0 0
devpts   /dev/pts devpts  gid=5,mode=0620     0 0
tmpfs    /run    tmpfs    nosuid,nodev,mode=0755 0 0
tmpfs    /tmp    tmpfs    nosuid,nodev,mode=1777 0 0
EOF
fi
printf 'DEROX rootfs directory skeleton created: %s\n' "$ROOTFS"
printf 'Note: this is not a complete root filesystem.\n'
