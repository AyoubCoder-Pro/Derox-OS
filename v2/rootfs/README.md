# DEROX root filesystem layout

`create-rootfs-skeleton.sh` creates a standard directory layout inside an existing target rootfs directory.

## Usage

```bash
mkdir -p /path/to/derox-rootfs
bash v2/rootfs/create-rootfs-skeleton.sh /path/to/derox-rootfs
```

It creates common top-level, `/usr`, and `/var` directories, sets sticky permissions on `/tmp` and `/var/tmp`, writes a layout marker, and creates an `/etc/fstab` template only when one does not already exist.

## Safety and scope

- Refuses to run as root and refuses `/` as the target.
- Does not create device nodes, users, symlinks, binaries, libraries, or a package database.
- Does not install a kernel, initramfs, bootloader, systemd, or desktop.
- Preserves an existing `/etc/fstab`.
- This is only a directory skeleton, not a complete or bootable root filesystem.

## Test

```bash
bash v2/rootfs/test-create-rootfs-skeleton.sh
```

## Minimum runtime validation

Before preparing a compressed live root, run:

```bash
bash v2/rootfs/check-rootfs-runtime.sh /path/to/derox-rootfs
```

The checker requires an executable systemd init, shell, `env`, init entry point, non-empty `/etc/os-release` and `/etc/fstab`, and core runtime directories. It is a structural preflight only; passing it does not prove that the rootfs boots or that all shared-library dependencies are present.

Test it with:

```bash
bash v2/rootfs/test-check-rootfs-runtime.sh
```
