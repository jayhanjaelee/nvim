return {
  'ChmaraX/herdr-nvim',
  config = function()
    require('herdr-nvim').setup({ keymaps = false })

    vim.keymap.set('n', '<leader>ac', '<CMD>Herdr comment<CR>', { desc = 'Comment' })
    vim.keymap.set('x', '<leader>ac', ':Herdr comment<CR>', { desc = 'Comment' }) -- `:` passes the selection

    vim.keymap.set('n', '<leader>al', '<CMD>Herdr list<CR>', { desc = 'List comments' })
    vim.keymap.set('n', '<leader>aS', '<CMD>Herdr send<CR>', { desc = 'Send comments to agent' })
    vim.keymap.set('n', '<leader>as', '<CMD>Herdr submit<CR>', { desc = 'Submit comments to agent' })
  end,
}
