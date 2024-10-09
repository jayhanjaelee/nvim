return {
  "navarasu/onedark.nvim",
  priority = 1000,
  fazy = false,
  config = function()
    -- vim.cmd([[colorscheme onedark]])
    require('onedark').setup({
      transparent = true,
      -- Options are italic, bold, underline, none
      -- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
      code_style = {
        comments = 'italic',
        keywords = 'none',
        functions = 'none',
        strings = 'none',
        variables = 'none'
      },
      lualine = {
        transparent = true
      },
      require('onedark').load(),
    })

    -- disable italic
    local hl_groups = vim.api.nvim_get_hl(0, {})

    for key, hl_group in pairs(hl_groups) do
      if hl_group.italic then
        vim.api.nvim_set_hl(0, key, vim.tbl_extend("force", hl_group, {italic = false}))
      end
    end
  end,
}
