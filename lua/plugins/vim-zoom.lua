return {
  "dhruvasagar/vim-zoom",
  config = function()
    vim.keymap.set("n", "<C-w>z", "<cmd>:call zoom#toggle()<cr>")
  end
}
