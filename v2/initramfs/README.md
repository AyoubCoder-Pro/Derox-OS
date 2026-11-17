# DEROX initramfs stage

`create-initramfs.sh` packages a prepared target root filesystem as a gzip-compressed `cpio newc` archive. It requires an executable `/init`, refuses root execution, writes atomically through a temporary file, and checks gzip integrity.

Example:

```bash
bash v2/initramfs/create-initramfs.sh /build/rootfs /build/artifacts/derox-initramfs.cpio.gz
```

The target rootfs must already contain a real init program and every required early-boot tool, library, device setup rule, and kernel module needed to mount and switch to the real root. This helper does not create those files, does not compile a kernel, and does not create a bootloader configuration or ISO.

The automated test uses a mock `cpio` command to test archive plumbing and safety checks. It does not prove that the archive can boot a machine.
