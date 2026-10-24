return {
  {
    'benlubas/molten-nvim',
    version = '^1.0.0', -- use version <2.0.0 to avoid breaking changes
    dependencies = { '3rd/image.nvim' },
    build = ':UpdateRemotePlugins',
    init = function()
      -- these are examples, not defaults. Please see the readme
      vim.g.molten_image_provider = 'image.nvim'
      vim.g.molten_output_win_max_height = 20
    end,
    config = function()
      require("image").setup({
        backend = "kitty",
        processor = "magick_cli",
        max_width = 100,
        max_height = 12,
        max_height_window_percentage = 100,
        max_width_window_percentage = 100,
        window_overlap_clear_enabled = true,
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs" },
      })

      -- Paste the notebook command code here!
      -- Template for a minimal, valid Python notebook
      local default_notebook = [[
        {
          "cells": [
           {
            "cell_type": "markdown",
            "metadata": {},
            "source": [
              ""
            ]
           },
	      {
          "cell_type": "code",
          "metadata": {},
          "source": [
        "print('Hello from Molten Python cell!')"
          ],
          "outputs": [],
          "execution_count": null
	       }
          ],
          "metadata": {
           "kernelspec": {
            "display_name": "Python 3",
            "language": "python",
            "name": "python3"
           },
           "language_info": {
            "codemirror_mode": {
              "name": "ipython"
            },
            "file_extension": ".py",
            "mimetype": "text/x-python",
            "name": "python",
            "nbconvert_exporter": "python",
            "pygments_lexer": "ipython3"
           }
          },
          "nbformat": 4,
          "nbformat_minor": 5
        }
      ]]

      local function new_notebook(filename)
        local path = filename .. '.ipynb'
        local file = io.open(path, 'w')
        if file then
          file:write(default_notebook)
          file:close()
          vim.cmd('edit ' .. path)
        else
          print 'Error: Could not open new notebook file for writing.'
        end
      end

      vim.api.nvim_create_user_command('NewNotebook', function(opts)
        new_notebook(opts.args)
      end, {
        nargs = 1,
        complete = 'file',
      })
    end,
  },
}
