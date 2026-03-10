return {
  'mhinz/vim-signify',
  desc = 'Git change indicator showing modifications in the sign column',
  event = 'BufReadPost',
  config = function()
    -- Update time for sign refresh
    vim.opt.updatetime = 100

    -- View diff of current file
    vim.keymap.set('n', '<leader>gd', ':SignifyDiff<cr>', { noremap = true, desc = 'SignifyDiff' })
    -- View diff of current hunk
    vim.keymap.set('n', '<leader>gp', ':SignifyHunkDiff<cr>', { noremap = true, desc = 'SignifyHunkDiff' })
    -- Undo changes in current hunk
    vim.keymap.set('n', '<leader>gu', ':SignifyHunkUndo<cr>', { noremap = true, desc = 'SignifyHunkUndo' })
  end
}
