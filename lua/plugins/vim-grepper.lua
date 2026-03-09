return {
  'mhinz/vim-grepper',
  cmd = { 'Grepper', 'GrepperRg', 'GrepperGit', 'GrepperGrep' },
  keys = {
    { '<leader>gr', '<cmd>Grepper<cr>', desc = 'Grepper' },
  },
  config = function()
    vim.g.grepper = { tools = { 'rg', 'grep', 'git' } }
  end,
}
