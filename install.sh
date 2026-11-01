#!/usr/bin/env bash
# dottyfiles installer: symlinks each config into ~/.config/
# Idempotent - safe to re-run. Never clobbers an existing config; it skips
# any target that already exists and is not already the intended link.
#
# Usage: ./install.sh

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

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

echo "Done. Restart your terminal and apps to pick up the configs."
