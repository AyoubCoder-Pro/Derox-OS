# DEROX OS 2.0 bootloader theme

This directory defines the GRUB2 theme integration for the black-and-purple DEROX boot screen.

## Asset required

The generated PNG artwork is 1672 × 941. It must be committed as:

`v2/bootloader/assets/derox-2.0-bootloader.png`

The image is not yet stored in this repository; the generated image currently exists as a conversation attachment. Do not claim the ISO contains it until the binary asset is committed and the ISO has been built.

## Stage into a target root filesystem

On a Linux build host with GRUB tools installed:

```bash
bash v2/bootloader/stage-theme.sh /path/to/target-rootfs v2/bootloader/assets/derox-2.0-bootloader.png
```

The ISO builder must:
- Set `GRUB_THEME=/boot/grub/themes/derox/theme.txt` in the generated GRUB configuration.
- Include the theme directory in the boot image.
- Load the appropriate GRUB video, PNG, font, and theme modules for the target firmware.
- Test both UEFI and legacy BIOS boot where supported.

The staging script deliberately requires an explicit image path and does not alter the host system.

## Current status

Theme definition and rootfs staging helper are prepared. Binary artwork repository integration, GRUB configuration generation, ISO build, and VM boot tests remain pending.
