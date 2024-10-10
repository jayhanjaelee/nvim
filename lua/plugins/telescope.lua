local mapKey = require("utils.keyMapper").mapKey

return {
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require("telescope.builtin")
      local themes = require('telescope.themes')

      mapKey('<Leader>ff', function()
        builtin.find_files(themes.get_ivy({}))
      end)

      mapKey('<Leader>fg', function()
        builtin.live_grep(themes.get_ivy({}))
      end)

      mapKey('<Leader>fb', function()
        builtin.buffers(themes.get_ivy({}))
      end)

      mapKey('<Leader>fh', function()
        builtin.help_tags(themes.get_ivy({}))
      end)
      -- mapKey('<leader>ff', builtin.find_files)
      -- mapKey('<leader>fg', builtin.live_grep)
      -- mapKey('<leader>fb', builtin.buffers)
      -- mapKey('<leader>fh', builtin.help_tags)

      -- change border
      vim.api.nvim_set_hl(0, 'TelescopeResultsBorder', { fg = "#5c6370" })
      vim.api.nvim_set_hl(0, 'TelescopePreviewBorder', { fg = "#5c6370" })
      vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { fg = "#5c6370" })
      vim.api.nvim_set_hl(0, 'TelescopeBorder', { fg = "#5c6370" })
    end,
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    config = function()
      require('telescope').setup({
        defaults = {
          file_ignore_patterns = {
            'node_modules',
            'vendor/*',
            '.*min.js',
            -- '.*.log'
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {
            }
          }
        }
      })
      require("telescope").load_extension("ui-select")
    end
  }
}
