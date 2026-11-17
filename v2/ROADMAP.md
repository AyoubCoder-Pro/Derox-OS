# DEROX OS 2.0 roadmap

All milestones are planned; none should be marked complete until tested and reviewed.

- [x] Create a separate `derox-2.0` development branch.
- [x] Record the independent-from-other-distributions goal and initial architecture.
- [x] Define the first package manifest schema and add a read-only validator with unit tests.
- [x] Remove the Debian 1.0 ISO workflow and legacy live-build hook from this branch.
- [x] Select and pin the stable LFS systemd 13.1 book revision.
- [ ] Pin the matching BLFS desktop component set and exact source checksums.
- [x] Add a source-lock format, read-only validator, unit tests, and CI checks; source list intentionally remains empty until upstream checksums are verified.
- [x] Document the staged build process, host requirements, and evidence-based build gates.
- [x] Add a non-invasive Linux x86_64 build-host preflight checker and CI syntax/help checks.\n- [x] Add tested DEROX OS identity staging for target root filesystems (os-release, issue, hostname, MOTD, release metadata).
- [x] Add a source downloader that enforces HTTPS, safe archive names, and SHA-256 verification, with unit tests.
- [ ] Create reproducible bootstrap and base-system build recipes.
- [ ] Build a minimal system and boot it in QEMU/VirtualBox.
- [ ] Add networking, certificates, and hardware support.
- [ ] Build ALSA + PipeWire + WirePlumber audio stack; verify speakers, headphones, microphones, volume controls, and device switching (see `v2/audio/README.md`).
- [ ] Add Bluetooth audio through BlueZ and PipeWire after basic audio is validated.
- [ ] Build and test the XFCE desktop session.
- [x] Create an official DEROX 2.0 purple-galaxy SVG wallpaper asset.
- [ ] Integrate the wallpaper into the XFCE desktop image and verify it in a booted session.
- [x] Define the initial DEROX package manifest schema and read-only validator.
- [ ] Implement signed repository metadata verification.
- [ ] Implement `derox-pkg` install, remove, upgrade, and recovery.
- [ ] Implement DEROX App Manager.
- [ ] Commit the generated black bootloader PNG and validate the GRUB theme asset.\n  - [x] Add and pass automated tests for the GRUB theme staging helper.
- [ ] Integrate the GRUB theme into BIOS/UEFI boot configuration and test both firmware paths.
- [ ] Produce a reproducible live ISO.
- [ ] Test installation, updates, rollback/recovery, and SHA-256 release verification.
- [ ] Publish a clearly labelled alpha release.

## Release rule

Do not publish a 2.0 ISO as stable until clean builds and virtual-machine tests pass. Keep the existing 1.0 release and Debian-based workflow untouched.
