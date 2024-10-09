local jaylee = vim.api.nvim_create_augroup("jaylee", {
    clear = false
})

vim.api.nvim_create_autocmd({'BufWinEnter'}, {
  group = jaylee,
  desc = 'Restore cursor last position.',
  pattern = '*',
  command = 'silent! normal! g`"zv',
})

-- text format
vim.cmd([[autocmd BufNewFile,BufRead,BufWinEnter * set formatoptions-=c]])
vim.cmd([[autocmd BufNewFile,BufRead,BufWinEnter * set formatoptions-=r]])
vim.cmd([[autocmd BufNewFile,BufRead,BufWinEnter * set formatoptions-=o]])

-- indent for file type
vim.cmd([[autocmd FileType php setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab]])
