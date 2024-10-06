local mapKey = require("utils.keyMapper").mapKey

-- local actions = require('telescope.actions')
-- local action_state = require('telescope.actions.state')
--
-- function custom_actions.fzf_multi_select(prompt_bufnr)
--   local picker = action_state.get_current_picker(prompt_bufnr)
--   local num_selections = table.getn(picker:get_multi_selection())
--
--   if num_selections > 1 then
--     local picker = action_state.get_current_picker(prompt_bufnr)
--     for _, entry in ipairs(picker:get_multi_selection()) do
--       vim.cmd(string.format("%s %s", ":e!", entry.value))
--     end
--     vim.cmd('stopinsert')
--   else
--     actions.file_edit(prompt_bufnr)
--   end
-- end

return {
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require("telescope.builtin")
      mapKey('<leader>ff', builtin.find_files)
      mapKey('<leader>fg', builtin.live_grep)
      mapKey('<leader>fb', builtin.buffers)
      mapKey('<leader>fh', builtin.help_tags)

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
          -- mappings = {
          --   i = {
          --     ['<esc>'] = actions.close,
          --     ['<C-j>'] = actions.move_selection_next,
          --     ['<C-k>'] = actions.move_selection_previous,
          --     ['<tab>'] = actions.toggle_selection + actions.move_selection_next,
          --     ['<s-tab>'] = actions.toggle_selection + actions.move_selection_previous,
          --     ['<cr>'] = custom_actions.fzf_multi_select,
          --   },
          --   n = {
          --     ['<esc>'] = actions.close,
          --     ['<tab>'] = actions.toggle_selection + actions.move_selection_next,
          --     ['<s-tab>'] = actions.toggle_selection + actions.move_selection_previous,
          --     ['<cr>'] = custom_actions.fzf_multi_select
          --   }
          -- },
          file_ignore_patterns = {
            '^node_modules/',
            'vendor/*',
            '.*min.js'
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
