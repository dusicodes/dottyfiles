# dottyfiles

Personal configuration files for a terminal-based development setup: a
Neovim editor config, a Kitty terminal config, a herdr workspace config, an
opencode agent config, and an installer that links them all into place.

## Neovim

`nvim/init.lua` is a one-liner that loads the `dusicodes` module; the real
config lives in `nvim/lua/dusicodes/`.

- `set.lua` - editor options: relative line numbers, 2-space indentation,
  persistent undo, diagnostic styling, and the Molten notebook settings.
- `remap.lua` - keymaps: leader-key shortcuts, window and split navigation,
  and keys for running code cells.
- `lazy_init.lua` - bootstraps lazy.nvim, the plugin manager.
- `lazy/*.lua` - one file per plugin: LSP and completions, Treesitter,
  Telescope, Oil, Snacks, Lualine, Trouble, git integration (gitsigns,
  fugitive, lazygit), Harpoon, Flash, formatting via conform, and more.
- `floatingtodo.lua` - a small custom plugin that opens `~/notes/todo.md` in
  a floating window.
- `colors/custom.vim` - a custom dark colorscheme.

Notebooks are a running theme: Molten, Quarto, and Jupytext run
Python/Jupyter cells inside Markdown, Quarto, and `.ipynb` files,
`ftplugin/markdown.lua` activates Quarto in Markdown files, and `set.lua`
adds a `NewNotebook` command.

## Kitty

`kitty/kitty.conf` sets the font (Iosevka Nerd Font Mono at size 20), a dark
background/foreground pair, a cursor trail, and tab bar styling. The file is
mostly Kitty's own reference documentation kept as comments; the active
settings are only a handful of lines.

## herdr

`herdr/config.toml` configures herdr, the terminal workspace manager. It
disables onboarding, applies a custom nord-based color theme, and sets
tmux-style keybindings with prefix `ctrl+s` for splitting and cycling panes
and managing tabs.

## opencode

`opencode/opencode.jsonc` is deliberately minimal (it only pins the config
schema). Everything interesting lives alongside it:

- `themes/custom.json` - a custom color theme matching the rest of this
  setup.
- `tui.json` - TUI settings that select that theme.
- `tui.jsonc` - loads the herdr TUI plugin.
- `plugins/herdr-agent-state.js` and `herdr-tui-session.js` - herdr
  integration that reports what opencode is doing back to the workspace
  manager.
- `AGENTS.md` - global agent instructions for opencode sessions.

## Install

Run `./install.sh` from the repository. It symlinks `nvim`, `opencode`,
`herdr`, and `kitty` into `~/.config` (or `$XDG_CONFIG_HOME` if set). The
script is idempotent and never clobbers anything: an existing config, or a
symlink pointing elsewhere, is skipped with a message, and only missing
targets get linked. Restart your terminal and apps afterwards to pick up the
configs.
