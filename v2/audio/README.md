# DEROX 2.0 audio support

## Target

DEROX 2.0 desktop images are intended to support:
- Built-in and USB speakers, headphones, and headsets.
- Built-in, USB, and headset microphones.
- Per-device output/input selection, volume and mute controls.
- Applications using the PulseAudio-compatible client interface.

## Planned audio stack

| Component | Purpose |
|---|---|
| Linux kernel sound drivers (ALSA) | Hardware drivers and kernel audio interfaces |
| alsa-lib / alsa-utils | ALSA userspace library and diagnostic utilities |
| PipeWire | Audio routing and low-latency media server |
| WirePlumber | PipeWire session and device policy manager |
| pipewire-alsa | ALSA application compatibility |
| pipewire-pulse | PulseAudio application compatibility |
| pavucontrol | GUI for selecting output/input devices and adjusting levels |
| XFCE panel audio plugin | Desktop volume control |

Package versions and source hashes must be pinned in the source lock before they can enter a build. Do not copy package versions or checksums from unverified third-party lists.

## Session integration requirements

- Start PipeWire and WirePlumber in each logged-in desktop user's session using their upstream systemd user units.
- Enable the PipeWire PulseAudio-compatible service/socket for legacy desktop applications.
- Keep ALSA available as the hardware interface and diagnostic fallback.
- Include the XFCE audio panel plugin and a graphical mixer in the desktop profile.
- Do not hard-code a particular sound card or microphone as the default; let WirePlumber select available devices and allow the user to change them.
- Bluetooth headset audio is a separate integration milestone requiring BlueZ and compatible PipeWire Bluetooth support.

## Validation before calling audio supported

1. Confirm playback devices appear in the desktop audio settings.
2. Play a test sound through built-in speakers, headphones, and a USB audio device where available.
3. Confirm microphone capture and input-level meters work.
4. Confirm mute, volume, and device switching persist within a session.
5. Confirm a normal user session works without running audio applications as root.
6. Repeat tests in a virtual machine and on physical hardware; VM audio alone does not prove physical driver coverage.

## Current status

**Design documented; not yet implemented or hardware-tested.** DEROX 2.0 does not yet have a bootable root filesystem or ISO. Audio support must not be advertised as working until the stack is built and the tests above pass.
