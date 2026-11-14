# DEROX OS 2.0 roadmap

All milestones are planned; none should be marked complete until tested and reviewed.

- [x] Create a separate `derox-2.0` development branch.
- [x] Record the independent-from-other-distributions goal and initial architecture.
- [x] Define the first package manifest schema and add a read-only validator with unit tests.
- [x] Remove the Debian 1.0 ISO workflow and legacy live-build hook from this branch.
- [x] Select and pin the stable LFS systemd 13.1 book revision.
- [ ] Pin the matching BLFS desktop component set and exact source checksums.
- [ ] Create reproducible bootstrap and base-system build recipes.
- [ ] Build a minimal system and boot it in QEMU/VirtualBox.
- [ ] Add networking, certificates, audio, and hardware support.
- [ ] Build and test the XFCE desktop session.
- [x] Create an official DEROX 2.0 purple-galaxy SVG wallpaper asset.
- [ ] Integrate the wallpaper into the XFCE desktop image and verify it in a booted session.
- [x] Define the initial DEROX package manifest schema and read-only validator.
- [ ] Implement signed repository metadata verification.
- [ ] Implement `derox-pkg` install, remove, upgrade, and recovery.
- [ ] Implement DEROX App Manager.
- [ ] Produce a reproducible live ISO.
- [ ] Test installation, updates, rollback/recovery, and SHA-256 release verification.
- [ ] Publish a clearly labelled alpha release.

## Release rule

Do not publish a 2.0 ISO as stable until clean builds and virtual-machine tests pass. Keep the existing 1.0 release and Debian-based workflow untouched.
