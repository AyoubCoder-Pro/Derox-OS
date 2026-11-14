# DEROX 2.0 build preparation

This directory contains host preflight checks and the documented build boundary. It does **not** yet contain a complete LFS bootstrap or root-filesystem builder.

## Host requirements

Run the preflight from a native 64-bit Linux environment:

```bash
bash v2/build/host-check.sh
```

Recommended for a full source build:

- x86_64 Linux host
- 8 GiB RAM minimum; 16 GiB recommended
- 60 GiB free disk space minimum; more is preferable for cached sources and build logs
- A stable network connection
- A dedicated, disposable build directory

The checker reports resource recommendations as warnings. It does not install packages, change system settings, or require root.

## Build sequence

1. Review the pinned LFS systemd 13.1 book and its current errata.
2. Populate `v2/sources/sources.json` with individually verified HTTPS URLs, exact archive names, licenses, and SHA-256 checksums.
3. Run the source-lock validator in CI and locally.
4. Implement and review the temporary toolchain recipes.
5. Build the target base system in an isolated, reproducible environment.
6. Boot the minimal system in QEMU or VirtualBox and save logs.
7. Add networking and desktop components only after the minimal boot milestone passes.
8. Build the live image and installer only after live-session and recovery tests pass.

## Safety and reproducibility rules

- Never copy checksums from unverified mirrors or invent placeholder digests.
- Never extract an archive before its checksum has been verified.
- Never run a build as root unless a specific, reviewed step requires it.
- Keep downloaded source archives separate from extracted trees and build output.
- Record source versions, checksums, compiler flags, host details, and build logs.
- Do not use the Debian-based 1.0 build workflow as the 2.0 runtime base.

## Current limitation

The source lock is intentionally empty. Therefore no bootstrap or base-system build can start yet. This is an explicit safety gate, not a successful build. DEROX 2.0 is still not bootable and has no ISO.
