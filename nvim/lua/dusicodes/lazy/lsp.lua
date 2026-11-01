return {
  -- ===============================
  -- Mason
  -- ===============================
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
    },
  },

  -- ===============================
  -- LSP setup (new vim.lsp API)
  -- ===============================
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.o.winborder = "rounded"

      -- 1️⃣ Define LSP servers
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            format = {
              enable = true,
              defaultConfig = {
                indent_style = "space",
                indent_size = 4,
              },
            },
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
          },
        },
      })

      vim.lsp.config("pyright", { capabilities = capabilities, filetypes = { "python" } })
      vim.lsp.config("html", { capabilities = capabilities })
      vim.lsp.config("hls", { capabilities = capabilities })
      vim.lsp.config("clangd", { capabilities = capabilities })
      vim.lsp.config("taplo", { capabilities = capabilities })

      -- 2️⃣ Enable servers
      vim.lsp.enable("lua_ls")
      vim.lsp.enable("pyright")
      vim.lsp.enable("html")
      vim.lsp.enable("hls")
      vim.lsp.enable("clangd")
      vim.lsp.enable("taplo")

      -- 3️⃣ Keymaps
      local keymap = vim.keymap.set
      local opts = { noremap = true, silent = true }

      keymap("n", "K", vim.lsp.buf.hover, opts)
      keymap("n", "<leader>gd", vim.lsp.buf.definition, opts)
      keymap("n", "<leader>gr", vim.lsp.buf.references, opts)
      keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)

      -- Manual format key
      keymap("n", "<leader>f", function()
        require("conform").format()
      end, { desc = "Format buffer" })

      -- Optional: autoformat after paste (can remove if annoying)
      for _, mode in ipairs({ "n", "v" }) do
        keymap(mode, "p", "p<cmd>lua vim.lsp.buf.format({ async = true })<CR>", opts)
        keymap(mode, "P", "P<cmd>lua vim.lsp.buf.format({ async = true })<CR>", opts)
      end
    end,
  },

  -- ===============================
  -- TypeScript Tools
  -- ===============================
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    config = function()
      vim.diagnostic.config({
        signs = false,
        virtual_text = true,
        underline = true,
      })
      require("typescript-tools").setup({
        settings = {
          tsserver_plugins = {},
        },
      })
    end,
  },
}
