#!/usr/bin/env bash
# dottyfiles installer: symlinks each config into ~/.config/ and refreshes
# the pi config in ~/.pi/agent/ from the repo copies.
# Idempotent - safe to re-run. Symlink targets are never clobbered; the pi
# files are plain copies overwritten with the repo version.
#
# Usage: ./install.sh

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
PI_DIR="$HOME/.pi/agent"

mkdir -p "$CONFIG_DIR"

link() {
  local name="$1"
  local src="$DOTFILES_DIR/$name"
  local dst="$CONFIG_DIR/$name"

  if [ -L "$dst" ]; then
    if [ "$(readlink "$dst")" = "$src" ]; then
      printf 'ok   ~/.config/%s (already linked)\n' "$name"
      return 0
    fi
    printf 'skip ~/.config/%s (existing symlink points elsewhere)\n' "$name"
    return 0
  fi
  if [ -e "$dst" ]; then
    printf 'skip ~/.config/%s (exists; move it away first)\n' "$name"
    return 0
  fi

  ln -s "$src" "$dst"
  printf 'link ~/.config/%s -> %s\n' "$name" "$src"
}

link nvim
link opencode
link herdr
link kitty

refresh_pi() {
  mkdir -p "$PI_DIR/themes"
  cp "$DOTFILES_DIR/pi/settings.json" "$PI_DIR/settings.json"
  cp "$DOTFILES_DIR/pi/themes/opencode.json" "$PI_DIR/themes/opencode.json"
  cp "$DOTFILES_DIR/pi/AGENTS.md" "$PI_DIR/AGENTS.md"
  printf 'copy ~/.pi/agent/settings.json (refreshed from repo)\n'
  printf 'copy ~/.pi/agent/themes/opencode.json (refreshed from repo)\n'
  printf 'copy ~/.pi/agent/AGENTS.md (refreshed from repo)\n'
}

refresh_pi

echo "Done. Restart your terminal and apps to pick up the configs."
