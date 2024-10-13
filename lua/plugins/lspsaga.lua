return {
  'nvimdev/lspsaga.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter', -- optional
    'nvim-tree/nvim-web-devicons',     -- optional
  },
  config = function()
    local keymap = vim.keymap.set
    require('lspsaga').setup({
      symbol_in_winbar = {
        enable = false,
        folder_level = 1
      },
      lightbulb = {
        enable = false
      },
      text_hl_follow = false,
      show_layout = 'normal',

      -- key mapping
      -- keymap("n", "<leader>m", "<cmd>Lspsaga show_buf_diagnostics ++normal<CR>"),
      -- keymap("n", "<leader>sw", "<cmd>Lspsaga show_workspace_diagnostics ++normal<CR>"),
      -- Diagnostic jump,
      -- You can use <C-o> to jump back to your previous location,
      keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>"),
      keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>"),
      -- Toggle outline,
      -- keymap("n","<leader>o", "<cmd>Lspsaga outline<CR>"),
      keymap({"n", "t"}, "<A-d>", "<cmd>Lspsaga term_toggle<CR>"),
    })
  end,
}
