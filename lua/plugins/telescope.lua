local mapKey = require("utils.keyMapper").mapKey

return {
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup{
        defaults = {
          layout_strategy = 'ivy',
          layout_config = { height = 0.1 }
        },
        pickers = {
        },
        extensions = {
          recent_files = {
            ignore_patterns = {}
          }
        }
      }

      local builtin = require("telescope.builtin")
      local themes = require('telescope.themes')

      local opts = {
        layout_config = { height = 0.5 }
      }

      mapKey('<Leader>ff', function()
        builtin.find_files(themes.get_ivy(opts))
      end)

      mapKey('<Leader>fg', function()
        builtin.live_grep(themes.get_ivy(opts))
      end)

      mapKey('<Leader>fb', function()
        builtin.buffers(themes.get_ivy(opts))
      end)

      mapKey('<Leader>fh', function()
        builtin.help_tags(themes.get_ivy(opts))
      end)

      mapKey('gr', function()
        builtin.lsp_references(themes.get_ivy({
          layout_config = { height = 0.5 },
          show_line = false
        }))
      end)

      mapKey('<leader>m', function()
        builtin.diagnostics(themes.get_ivy(
          { bufnr = 0, layout_config = { height = 0.5 } }
        ))
      end)
      
      -- mapKey('gr', function()
      --   builtin.lsp_references(themes.get_ivy({}))
      -- end)
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
  },
  {
    "smartpde/telescope-recent-files",
    config = function()
      require('telescope').setup({
        require('telescope').load_extension("recent_files")
      })
      -- Map a shortcut to open the picker.
      vim.api.nvim_set_keymap("n", "<leader>r",
        [[<cmd>lua require('telescope').extensions.recent_files.pick(require('telescope.themes').get_ivy({}))<CR>]],
        {noremap = true, silent = true})
    end
  }
}
