# AYOUB OS

A personal Ubuntu/Linux terminal identity with a light-cyan ASCII logo and Fastfetch system dashboard.

This project customizes an existing Ubuntu/Debian-based Linux environment. It does not replace the operating system or repartition your disk.

## Features

- Light-cyan AYOUB OS ASCII logo
- Fastfetch dashboard: OS, kernel, shell, terminal, CPU, and memory
- ayoub command to display the branded dashboard
- Optional Fastfetch installation on Ubuntu/Debian
- Safe setup: backs up .bashrc before adding the startup banner

## Install

Clone the repository, enter its folder, and run:

    git clone https://github.com/AyoubCoder-Pro/Ayoub-OS.git
    cd Ayoub-OS
    bash install.sh

The installer may ask whether you want to install Fastfetch using apt. If you decline, the basic AYOUB OS banner still works.

Open a new terminal, or run source ~/.bashrc, then use:

    ayoub

## Files

- install.sh — installs the terminal profile and command
- bin/ayoub — branded dashboard command
- fastfetch/config.jsonc — Fastfetch configuration
- fastfetch/ayoub.txt — ASCII logo

## Uninstall

Remove the AYOUB OS block between the marker comments from ~/.bashrc, then remove:

    rm -f ~/.local/bin/ayoub
    rm -rf ~/.config/fastfetch

The installer creates a timestamped .bashrc.ayoub-os-backup.* backup before changing the shell startup file.

## License

MIT
