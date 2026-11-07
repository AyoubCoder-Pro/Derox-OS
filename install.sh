#!/usr/bin/env bash
set -Eeuo pipefail
ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config/fastfetch"
BIN_DIR="$HOME/.local/bin"
BASHRC="$HOME/.bashrc"
MARKER="# >>> AYOUB OS >>>"

mkdir -p "$CONFIG_DIR" "$BIN_DIR"
cp "$ROOT_DIR/fastfetch/config.jsonc" "$CONFIG_DIR/config.jsonc"
cp "$ROOT_DIR/fastfetch/ayoub.txt" "$CONFIG_DIR/ayoub.txt"
cp "$ROOT_DIR/bin/ayoub" "$BIN_DIR/ayoub"
chmod +x "$BIN_DIR/ayoub"

if ! command -v fastfetch >/dev/null 2>&1; then
  if command -v apt-get >/dev/null 2>&1; then
    read -r -p "Install Fastfetch with sudo apt? [y/N] " answer
    case "$answer" in
      y|Y|yes|YES) sudo apt-get update && sudo apt-get install -y fastfetch ;;
      *) printf 'Skipping Fastfetch installation.\n' ;;
    esac
  else
    printf 'Install Fastfetch with your package manager for system details.\n'
  fi
fi

if ! grep -Fq "$MARKER" "$BASHRC" 2>/dev/null; then
  if [ -f "$BASHRC" ]; then
    cp "$BASHRC" "$BASHRC.ayoub-os-backup.$(date +%Y%m%d-%H%M%S)"
  else
    touch "$BASHRC"
  fi
  cat >> "$BASHRC" <<'EOF'

# >>> AYOUB OS >>>
export PATH="$HOME/.local/bin:$PATH"
if command -v fastfetch >/dev/null 2>&1; then
  fastfetch
else
  printf '\033[38;5;117mAYOUB OS\033[0m - terminal profile ready\n'
fi
# <<< AYOUB OS <<<
EOF
fi

printf '\033[38;5;117mAYOUB OS terminal setup complete!\033[0m\n'
printf 'Open a new terminal or run: source ~/.bashrc\n'
printf 'Then run: ayoub\n'
