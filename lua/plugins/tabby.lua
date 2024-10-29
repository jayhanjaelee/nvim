return {
  'nanozuki/tabby.nvim',
  -- event = 'VimEnter', -- if you want lazy load, see below
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    -- configs...
    local theme = {
      fill = { fg = "#000000", bg = "#000000" },
      head = { fg = "#696969", bg = "#000000" },
      current_tab = { fg='#afb2b0', bg='#282828' },
      tab = { fg = "#696969", bg = "#000000" },
      win = { fg = "#696969", bg = "#000000" },
      tail = { fg = "#696969", bg = "#000000" },
    }
    require('tabby').setup({
      -- not working
      -- vim.api.nvim_set_hl(0, "MyTabLineFill", { fg = "#000000", bg = "#000000" }),
      -- vim.api.nvim_set_hl(0, "MyTabLine", { fg = "#696969", bg = "#000000" }),
      -- vim.api.nvim_set_hl(0, "MyTabLineSel", { fg='#afb2b0', bg='#282828' }),

      -- mapKey('<leader>s', ':Tabby pick_window<cr>'),
      vim.keymap.set("n", "<leader>,", ":Tabby rename_tab "),
      line = function(line)
        return {
          {
            -- { '  ', hl = theme.head }, -- vim logo
            { '  ', hl = theme.head }, -- neovim logo
            line.sep('', theme.head, theme.fill),
          },
          line.tabs().foreach(function(tab)
            local hl = tab.is_current() and theme.current_tab or theme.tab
            return {
              line.sep('', hl, theme.fill),
              -- tab.is_current() and '' or '󰆣',
              tab.number(),
              tab.name(),
              tab.close_btn(''),
              line.sep('', hl, theme.fill),
              hl = hl,
              margin = ' ',
            }
          end),
          line.spacer(),
          hl = theme.fill,
        }
      end,
      -- option = {}, -- setup modules' option,
    })
  end,
}
