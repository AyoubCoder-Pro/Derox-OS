# DEROX OS 1.0

**A Linux distribution for everyone.**

DEROX OS is an independent Debian-based live Linux project, built around Debian 12 (Bookworm) and the XFCE4 desktop. Version 1.0 is the first development release of the DEROX identity and live system.

> DEROX OS is an independent community project and is not affiliated with or endorsed by the Debian project.

## Version 1.0

- Debian 12 Bookworm base
- XFCE4 desktop environment
- amd64 / x86_64 hybrid live ISO
- LightDM login manager
- NetworkManager for network connections
- Firefox ESR and useful system tools
- DEROX OS welcome branding and `derox` terminal command

## DEROX OS 2.0 — a new distribution from scratch

DEROX OS 2.0 is a separate, ground-up project: its design, system structure, and distribution identity are being created from scratch. Unlike version 1.0, version 2.0 is **not based on Debian** (and is not a Debian, Ubuntu, or Arch derivative). It is being developed as an independent Linux distribution, using upstream open-source components such as the Linux kernel.

Version 2.0 is still under development. It does not yet have a completed, bootable ISO. The 1.0 release remains the Debian-based version described above; work on 2.0 does not change or replace that history.

## Build and download

The ISO is built with GitHub Actions:

1. Open the repository's **Actions** tab.
2. Select **Build DEROX OS 1.0 ISO**.
3. Run the workflow, or open the latest successful run.
4. Download the `derox-os-iso` artifact and extract the ZIP file.
5. Verify the ISO with the included SHA-256 checksum file.

### Join split download parts (Windows)

If a release is provided as multiple files such as `DEROX-OS-v1.0-amd64.iso.xz.part-000` and `DEROX-OS-v1.0-amd64.iso.xz.part-001`, join them **in numerical order** before extracting:

1. Download **all** parts and place them in the same folder. Make sure both files have their complete names and are not still downloading.
2. Open Command Prompt in that folder. In File Explorer, open the folder, click the address bar, type `cmd`, and press Enter.
3. Run this command:

   ```bat
   copy /b "DEROX-OS-v1.0-amd64.iso.xz.part-000"+"DEROX-OS-v1.0-amd64.iso.xz.part-001" "DEROX-OS-v1.0-amd64.iso.xz"
   ```

4. Wait for Windows to report that one file was copied. You should now have `DEROX-OS-v1.0-amd64.iso.xz` in that folder.
5. Extract the `.xz` file with 7-Zip or a compatible archive tool. The extracted file should be `DEROX-OS-v1.0-amd64.iso`.
6. Keep the original part files until you have checked that the ISO was extracted successfully.

**Important:** Do not extract each part separately, do not change their order, and do not use a text editor to combine them. If the release has more than two parts, add every part to the same command in order: `part-000`+`part-001`+`part-002`, and so on. The names above are examples; use the exact filenames shown on the release page.

## Try it safely

Test the live ISO in a virtual machine or boot it as a live USB before considering installation. Creating a bootable USB erases the USB drive, so back up its files first. The current image is a live system; it is not yet a full disk installer.

The ISO targets 64-bit (amd64) PCs. Hardware compatibility and performance still need testing on a range of computers.

## Project status

DEROX OS 1.0 is an initial release candidate for testing and feedback, not a claim of production-grade stability. Please report bugs and hardware compatibility results through GitHub Issues.

## Contributing

DEROX OS is an open-source community project. Everyone is welcome to inspect the source, fork the repository, modify their own copy, and propose improvements.

1. Fork this repository on GitHub.
2. Create a branch for your change.
3. Test your change and describe what you changed.
4. Open a Pull Request so the maintainers can review it.

You do not need write access to the original repository to contribute. Please open an Issue first for large changes or new features. Be respectful, explain your changes clearly, and do not include files or software that you do not have permission to redistribute.

## License

The original DEROX OS project files are licensed under the MIT License; see [LICENSE](LICENSE). Components included in the distribution (such as Debian packages, firmware, fonts, and other third-party software) remain under their own respective licenses. The DEROX name and logo are not automatically granted for use as someone else's project branding.
