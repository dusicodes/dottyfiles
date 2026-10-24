return {
  -- Tree-sitter
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",

    config = function()
      require("nvim-treesitter").setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      -- Install parsers using the new Tree-sitter API.
      require("nvim-treesitter").install({
        "bash",
        "c",
        "cpp",
        "css",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "rust",
        "toml",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      })

      -- Enable highlighting when a supported filetype opens.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "bash",
          "c",
          "cpp",
          "css",
          "diff",
          "html",
          "javascript",
          "javascriptreact",
          "json",
          "lua",
          "markdown",
          "python",
          "rust",
          "toml",
          "typescript",
          "typescriptreact",
          "vim",
          "vimdoc",
          "yaml",
        },
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },

  -- Automatically close and rename HTML tags.
  {
    "windwp/nvim-ts-autotag",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    event = "InsertEnter",

    opts = {
      enable_close = true,
      enable_rename = true,
      enable_close_on_slash = false,

      per_filetype = {
        html = {
          enable_close = false,
        },
      },
    },
  },

  -- Show the current function or class context.
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    event = "VeryLazy",

    opts = {
      enable = true,
      multiwindow = false,
      max_lines = 0,
      min_window_height = 0,
      line_numbers = true,
      multiline_threshold = 20,
      trim_scope = "outer",
      mode = "cursor",
      separator = nil,
      zindex = 20,
    },

    config = function(_, opts)
      require("treesitter-context").setup(opts)

      vim.api.nvim_set_hl(0, "TreesitterContext", {
        bg = "NONE",
      })

      vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", {
        bg = "NONE",
      })
    end,
  },
}
