# DEROX Linux kernel build stage

This directory contains the first kernel build/staging entry point for DEROX 2.0.

## Build contract

`build-kernel.sh` accepts:

1. An already verified and extracted Linux kernel source tree.
2. A separate out-of-tree build directory.
3. A target root filesystem directory (never the host root).
4. An optional kernel Kconfig fragment.

Example on a prepared Linux build host:

```bash
DEROX_BUILD_JOBS=2 bash v2/kernel/build-kernel.sh \
  /build/src/linux /build/work/linux /build/rootfs
```

The script refuses root execution, requires a separate build directory, selects x86_64, builds `bzImage` and modules, installs modules under the target rootfs, and stages the kernel image, config, and System.map under `/boot`. It does not run `make install` on the host.

## Important prerequisites

- The kernel source must come from a pinned entry in `v2/sources/sources.json`, downloaded with `v2/tools/fetch_sources.py`, and have its SHA-256 verified before extraction.
- The source archive must be extracted and reviewed before calling this script. This script does not download sources or verify archives itself.
- Build dependencies must be installed on a disposable, unprivileged Linux builder.
- A target root filesystem with a working init and device setup is still required to boot.
- An initramfs, GRUB configuration, live ISO, and installer are separate later stages.

## Test

```bash
bash v2/kernel/test-build-kernel.sh
```

The test uses a mock `make`; it verifies staging behavior, not a real kernel compilation or boot. The current empty source lock intentionally prevents a production kernel build until an upstream archive and trustworthy SHA-256 evidence are pinned.
