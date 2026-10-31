-- remap.lua (replace existing content)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.guicursor = "n-v-c-i:block"

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Gold rempaps
vim.keymap.set("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })
vim.keymap.set("n", "ss", ":split<Return>", opts)
vim.keymap.set("n", "sv", ":vsplit<Return>", opts)

-- Move window
vim.keymap.set("n", "sh", "<C-w>h")
vim.keymap.set("n", "sk", "<C-w>k")
vim.keymap.set("n", "sj", "<C-w>j")
vim.keymap.set("n", "sl", "<C-w>l")

-- Increment/decrement
vim.keymap.set("n", "+", "<C-a>")
-- Resize window
vim.keymap.set("n", "<C-w><left>", "<C-w><")
vim.keymap.set("n", "<C-w><right>", "<C-w>>")
vim.keymap.set("n", "<C-w><up>", "<C-w>+")
vim.keymap.set("n", "<C-w><down>", "<C-w>-")

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 40 })
  end,
})

vim.keymap.set("n", "-", function()
  require("oil").open(vim.fn.expand("%:p:h"))
end, { desc = "Open Parent Directory" })

-- Insert & terminal mode handlers for left/right too
vim.keymap.set("i", "<C-h>", "<Esc><C-w>h", opts)
vim.keymap.set("i", "<C-l>", "<Esc><C-w>l", opts)
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], opts)
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], opts)

vim.keymap.set("n", "<localleader>ip", function()
  local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
  if venv ~= nil then
    -- in the form of /home/benlubas/.virtualenvs/VENV_NAME
    venv = string.match(venv, "/.+/(.+)")
    vim.cmd(("MoltenInit %s"):format(venv))
  else
    vim.cmd("MoltenInit python3")
  end
end, { desc = "Initialize Molten for python3", silent = true })


vim.keymap.set("n", "<localleader>mi", ":MoltenInit<CR>",
  { silent = true, desc = "Initialize the plugin" })
vim.keymap.set("n", "<localleader>e", ":MoltenEvaluateOperator<CR>",
  { silent = true, desc = "run operator selection" })
vim.keymap.set("n", "<localleader>rr", ":MoltenReevaluateCell<CR>",
  { silent = true, desc = "re-evaluate cell" })

vim.keymap.set("n", "<localleader>os", ":noautocmd MoltenEnterOutput<CR>",
  { silent = true, desc = "show/enter output" })


local function runner()
  return require("quarto.runner")
end

vim.keymap.set("n", "<localleader>rc", function() runner().run_cell() end, { desc = "run cell", silent = true })
vim.keymap.set("n", "<localleader>ra", function() runner().run_above() end,
  { desc = "run cell and above", silent = true })
vim.keymap.set("n", "<localleader>rA", function() runner().run_all() end, { desc = "run all cells", silent = true })
vim.keymap.set("n", "<localleader>rl", function() runner().run_line() end, { desc = "run line", silent = true })
vim.keymap.set("v", "<localleader>r", function() runner().run_range() end, { desc = "run visual range", silent = true })
vim.keymap.set("n", "<localleader>RA", function() runner().run_all(true) end,
  { desc = "run all cells of all languages", silent = true })

vim.keymap.set("n", "<leader>td", function()
  require("dusicodes.floatingtodo").toggle()
end, { desc = "Toggle floating todo" })
