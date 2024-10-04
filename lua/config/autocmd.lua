local jaylee = vim.api.nvim_create_augroup("jaylee", {
    clear = false
})

vim.api.nvim_create_autocmd({'BufWinEnter'}, {
  group = jaylee,
  desc = 'Restore cursor last position.',
  pattern = '*',
  command = 'silent! normal! g`"zv',
})
