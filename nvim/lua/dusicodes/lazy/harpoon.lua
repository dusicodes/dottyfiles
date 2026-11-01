return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },

  config = function()
    local harpoon = require("harpoon")

    -- REQUIRED
    harpoon:setup()

    -- store the Harpoon list object once
    local harpoon_list = harpoon:list()

    ------------------------------------------------
    -- Safe toggle menu
    ------------------------------------------------
    local function toggle_menu()
      if harpoon_list and #harpoon_list.items > 0 then
        harpoon.ui:toggle_quick_menu(harpoon_list)
      else
        print("Harpoon list is empty!")
      end
    end

    ------------------------------------------------
    -- Add file
    ------------------------------------------------
    vim.keymap.set("n", "<leader>a", function()
      harpoon_list:add()
    end)

    ------------------------------------------------
    -- Open menu
    ------------------------------------------------
    vim.keymap.set("n", "<leader>m", toggle_menu)

    ------------------------------------------------
    -- Quick jump to files 1–4
    ------------------------------------------------
    --- change this
    for i = 1, 4 do
      vim.keymap.set("n", "<leader>" .. i, function()
        harpoon_list:select(i)
      end)
    end
  end,
}
