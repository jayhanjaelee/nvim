local mapKey = require("utils.keyMapper").mapKey

function telescope_open_single_or_multi(bufnr)
  local actions = require("telescope.actions")
  local actions_state = require("telescope.actions.state")
  local single_selection = actions_state.get_selected_entry()
  local multi_selection = actions_state.get_current_picker(bufnr):get_multi_selection()
  if not vim.tbl_isempty(multi_selection) then
    actions.close(bufnr)
    for _, file in pairs(multi_selection) do
      if file.path ~= nil then
        vim.cmd(string.format("edit %s", file.path))
      end
    end
    vim.cmd(string.format("edit %s", single_selection.path))
  else
    actions.select_default(bufnr)
  end
end

return {
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      local actions = require('telescope.actions')
      local themes = require('telescope.themes')

      require('telescope').setup{
        defaults = {
          layout_strategy = 'ivy',
          layout_config = { height = 0.1 },
          mappings = {
            i = {
              ['<esc>'] = actions.close,
              ['<C-j>'] = actions.move_selection_next,
              ['<C-k>'] = actions.move_selection_previous,
              ["<c-d>"] = actions.delete_buffer,
              ["<CR>"] = telescope_open_single_or_multi,
            },
            n = {
              ['<esc>'] = actions.close,
              ["dd"] = actions.delete_buffer,
            },
          }
        },
        pickers = {
        },
        extensions = {
          recent_files = {
            ignore_patterns = {}
          }
        }
      }

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
