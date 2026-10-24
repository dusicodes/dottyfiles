local enable = true

function ColorMyPencils(color)
  if not enable then
    return
  end
  color = color or "gruvbox"
  local ok = pcall(vim.cmd.colorscheme, color)
  if not ok then
    vim.notify("Colorscheme not found: " .. color, vim.log.levels.WARN)
  end

  local groups = {
    "Normal",
    "NormalNC",
    "LineNr",
    "SignColumn",
    "FoldColumn",
    "EndOfBuffer",
    "StatusLine",
    "StatusLineNC",
    "VertSplit",
  }
  for _, group in ipairs(groups) do
    vim.api.nvim_set_hl(0, group, { bg = "NONE" })
  end
end

return {

  {
    "RRethy/base16-nvim",
    lazy = false,
    priority = 1000,
    config = function()
      ColorMyPencils("base16-black-metal-gorgoroth")

      --   -- Make comments readable (base16 uses a nearly-invisible dark grey)
      --   vim.api.nvim_set_hl(0, "Comment", { fg = "#999999", italic = true })
      --   vim.api.nvim_set_hl(0, "TSComment", { fg = "#999999", italic = true })
      --
      --   -- Make unused/inactive variables visible instead of near-invisible
      --   vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { fg = "#8a8a8a", strikethrough = true })
      --   vim.api.nvim_set_hl(0, "LspDiagnosticsUnnecessary", { fg = "#8a8a8a", strikethrough = true })
    end
  },
  {
    'datsfilipe/vesper.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require("vesper").setup({ transparent = true })
      -- ColorMyPencils("vesper")
    end
  },
  {
    "zenbones-theme/zenbones.nvim",
    -- Optionally install Lush. Allows for more configuration or extending the colorscheme
    -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
    -- In Vim, compat mode is turned on as Lush only works in Neovim.
    dependencies = "rktjmp/lush.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.zenbones_darken_comments = 45
      -- ColorMyPencils("zenbones")
    end
  },
  {
    "shaunsingh/nord.nvim",
    name = "nord",
    lazy = false,
    priority = 1000,
    config = function()
      -- ColorMyPencils("nord")
    end,
  },
  {
    "ember-theme/nvim",
    name = "ember",
    priority = 1000,
    config = function()
      require("ember").setup({
        variant = "ember", -- "ember" | "ember-soft" | "ember-light" | "ember-lighter"
      })
      -- ColorMyPencils("ember")
    end,
  },

  {
    "WeiTing1991/suannhai.nvim",
    lazy = false,
    priority = 1000,
    build = "python3 scripts/sync-palettes.py",
    config = function()
      require("suannhai").setup({})
      -- ColorMyPencils("suannhai-hue-poo")
    end,
  },


  {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    config = function()
      require("gruvbox").setup({
        terminal_colors = true, -- add neovim terminal colors
        undercurl = true,
        underline = false,
        bold = true,
        italic = {
          strings = false,
          emphasis = false,
          comments = false,
          operators = false,
          folds = false,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = false, -- invert background for search, diffs, statuslines and errors
        contrast = "",   -- can be "hard", "soft" or empty string
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = false,
      })
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 999,
    config = function()
      require("tokyonight").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        style = "storm",        -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
        transparent = true,     -- Enable this to disable setting the background color
        terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
        styles = {
          -- Style to be applied to different syntax groups
          -- Value is any valid attr-list value for `:help nvim_set_hl`
          comments = { italic = false },
          keywords = { italic = false },
          -- Background styles. Can be "dark", "transparent" or "normal"
          sidebars = "dark", -- style for sidebars, see below
          floats = "dark",   -- style for floating windows
        },
      })
    end,
  },
}
