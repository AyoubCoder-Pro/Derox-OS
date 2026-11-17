# DEROX initramfs stage

`create-initramfs.sh` packages a prepared target root filesystem as a gzip-compressed `cpio newc` archive. It requires an executable `/init`, refuses root execution, writes atomically through a temporary file, and checks gzip integrity.

`init` is the early-userspace entry point. Use `install-init.sh` to install it at mode 0755 as `/init` inside the target initramfs root. It mounts proc/sys, reads the kernel `root=` command-line argument, mounts the real root filesystem, moves early virtual filesystems, and hands control to the real init system.

## Important limitations

This is an early-boot template, not a complete initramfs. A working image must also include a compatible shell, mount, switch_root, required shared libraries, device management, storage/filesystem drivers or modules, and any firmware needed to access the root device. Device discovery, UUID/LABEL resolution, encrypted/LVM/RAID roots, and recovery UX are not implemented yet.

Do not use this as a production initramfs until it has been integrated with a real root filesystem and boot-tested in QEMU/VirtualBox.

## Test

```bash
bash v2/initramfs/test-create-initramfs.sh
```

The automated archive test uses a mock `cpio` command; it checks packaging plumbing and safety guards, not successful boot.
