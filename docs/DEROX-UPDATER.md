# DEROX Updater

DEROX Updater is the graphical updater for the DEROX OS XFCE desktop.

## What it updates

- Refreshes the configured APT package indexes.
- Installs available updates for the operating system and installed applications using `apt-get upgrade`.
- Requests administrator authorization through PolicyKit (`pkexec`); it does not store or ask the user to share a password with the app.

## Safety and limitations

- It uses the signed APT repositories already configured on the system.
- It does not reinstall the ISO for normal package and security updates.
- It intentionally uses `apt-get upgrade`, not `full-upgrade`, to avoid automatically removing packages.
- A future major DEROX release or changes to the base image may still require a new ISO or a separately tested migration.
- Users should save their work before installing updates and restart if the updated kernel or core services require it.

## Build dependencies

The live image includes Python 3, PyGObject/GTK 3, and PolicyKit for the updater interface and authorization prompt.
