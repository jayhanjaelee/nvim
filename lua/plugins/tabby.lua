return {
  'nanozuki/tabby.nvim',
  -- event = 'VimEnter', -- if you want lazy load, see below
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    -- configs...
    local theme = {
      -- fill = 'TabLineFill',
      fill = { fg='#000000', bg='#000000' },
      head = 'TabLine',
      current_tab = 'TabLineSel',
      tab = 'TabLine',
      win = 'TabLine',
      tail = 'TabLine',
    }
    -- local mapKey = require('utils.keyMapper').mapKey
    require('tabby').setup({
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
          -- line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
          --   return {
          --     line.sep('', theme.win, theme.fill),
          --     win.is_current() and '' or '',
          --     win.buf_name(),
          --     line.sep('', theme.win, theme.fill),
          --     hl = theme.win,
          --     margin = ' ',
          --   }
          -- end),
          -- {
          --   line.sep('', theme.tail, theme.fill),
          --   { '  ', hl = theme.tail },
          -- },
          hl = theme.fill,
        }
      end,
      -- option = {}, -- setup modules' option,
    })
  end,
}
