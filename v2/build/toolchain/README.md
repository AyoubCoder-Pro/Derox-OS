# DEROX 2.0 bootstrap toolchain

This is the implementation contract for the first x86_64 cross-toolchain. It is **not yet a set of executable package recipes** and must not be described as a completed compiler build.

## Intended staged sequence

1. Verify the host, source lock, and every archive before extraction.
2. Create an isolated `$LFS/tools` prefix and an unprivileged temporary build user.
3. Build Binutils pass 1 for the target triplet.
4. Build GCC pass 1 with the matching target headers and temporary runtime.
5. Install Linux API headers into the target sysroot.
6. Build the target C library (glibc) against the temporary compiler.
7. Build libstdc++ and the remaining temporary utilities.
8. Rebuild Binutils and GCC against the target C library.
9. Record compiler identity, target triplet, flags, source lock digest, logs, and test results.

The exact configure flags, patches, environment variables, and install destinations must follow the pinned LFS 13.1-systemd chapters and be reviewed as DEROX recipes before execution. Do not mix instructions from the moving development book into this pinned build.

## Current gate

Run:

```bash
bash v2/build/check-build-gates.sh
```

The gate deliberately fails while `v2/sources/sources.json` is empty or any archive is missing/mismatched. It is read-only and does not build anything. This prevents an incomplete source inventory from being mistaken for a reproducible toolchain.

## Completion evidence

A toolchain milestone is complete only when a clean build log, compiler version output, target-triplet output, test results, and the exact source-lock revision are committed. A successful shell syntax check is not a compiler build.
