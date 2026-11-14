# DEROX OS 2.0 architecture

## Independence boundary

DEROX 2.0 will not use another Linux distribution's package database, repositories, root filesystem, installer, or release image as its base. It will compile and assemble its own base system from upstream source archives and maintain its own build recipes.

The Linux kernel and upstream projects remain external open-source components; DEROX is an independent distribution, not a new kernel.

## Proposed layers

1. **Bootstrap toolchain** — temporary compiler, linker, headers, and build utilities used to construct the target system.
2. **Base system** — C library, compiler runtime, shell, core utilities, init/service manager, device management, networking, certificates, and package-management foundations.
3. **Desktop** — X.Org or Wayland components as supported by the selected XFCE release, XFCE session, display manager, fonts, themes, and DEROX branding.
4. **DEROX package services** — package client, repository metadata, signing keys, dependency solver, and update service.
5. **Image and installer** — reproducible ISO generation, live boot, hardware detection, and a safe installer only after the live image is stable.

## Package and build principles

- Pin upstream versions and source checksums.
- Verify signatures where upstream projects publish them.
- Keep build recipes and patches in version control.
- Build in clean, isolated environments.
- Record compiler flags and build inputs.
- Sign repository metadata and release checksums.
- Never run package installation scripts from an untrusted repository as root without a reviewed, restricted design.

## Pinned upstream reference

- LFS systemd book: **13.1**, stable release published 2026-09-01.
- Official book: https://www.linuxfromscratch.org/lfs/downloads/stable-systemd/LFS-BOOK-13.1-NOCHUNKS.html
- Official stable download index: https://www.linuxfromscratch.org/lfs/download.html
- Track the matching LFS errata and security advisories before each build. Do not silently follow the development book.

The LFS book is a build reference, not a ready-made DEROX root filesystem. DEROX must maintain its own pinned source manifest, patches, build scripts, tests, and release process.

## Initial target

The first milestone is a minimal x86_64 system that boots in a virtual machine and provides a login shell. XFCE and the DEROX App Manager come after that milestone. The full desktop ISO is not the first build target.
