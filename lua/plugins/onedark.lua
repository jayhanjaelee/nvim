return {
  "navarasu/onedark.nvim",
  priority = 1000,
  fazy = false,
  config = function()
    -- vim.cmd([[colorscheme onedark]])
    require('onedark').setup({
      transparent = true,
      lualine = {
        transparent = true
      },
      require('onedark').load(),
    })
  end,
}
