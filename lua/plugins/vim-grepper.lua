return {
  'mhinz/vim-grepper',
  cmd = { 'Grepper', 'GrepperRg', 'GrepperGit', 'GrepperGrep' },
  keys = {
    { '<leader>gr', '<cmd>Grepper<cr>', desc = 'Grepper' },
  },
  config = function()
    vim.g.grepper = {
      tools = { 'rg', 'grep', 'git' },
      rg = {
        grepprg = 'rg -H --no-heading --vimgrep -g "!node_modules" -g "!vendor" -g "!.git"'
      }
    }
  end,
}
