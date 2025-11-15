return {
 'kevinhwang91/nvim-ufo',
  dependencies = 'kevinhwang91/promise-async',
  config = function()
    vim.o.foldcolumn = '0' -- '0' is not bad
    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    -- NOTE: Folding capabilities are configured in lua/plugins/lsp.lua
    require('ufo').setup()
  end,
}
