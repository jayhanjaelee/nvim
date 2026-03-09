return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  lazy = false,
  opts = {},
  config = function()
    require('refactoring').setup({
      -- prompt for return type
      prompt_func_return_type = {
        go = true,
        cpp = true,
        c = true,
        java = true,
      },
      -- prompt for function parameters
      prompt_func_param_type = {
        go = true,
        cpp = true,
        c = true,
        java = true,
      },

      printf_statements = {},
      print_var_statements = {},
      show_success_message = true,
    })
    -- prompt for a refactor to apply when the remap is triggered
    vim.keymap.set(
      {"n", "x"},
      "<leader>rr",
      function() require('refactoring').select_refactor() end
    )
    -- Note that not all refactor support both normal and visual mode
    vim.keymap.set({ "n", "x" }, "<leader>re", function() return require('refactoring').refactor('Extract Function') end, { expr = true, desc = "Extract Function" })
    vim.keymap.set({ "n", "x" }, "<leader>rf", function() return require('refactoring').refactor('Extract Function To File') end, { expr = true, desc = "Extract Function To File" })
    vim.keymap.set({ "n", "x" }, "<leader>rv", function() return require('refactoring').refactor('Extract Variable') end, { expr = true, desc = "Extract Variable" })
    vim.keymap.set({ "n", "x" }, "<leader>rI", function() return require('refactoring').refactor('Inline Function') end, { expr = true, desc = "Inline Function" })
    vim.keymap.set({ "n", "x" }, "<leader>ri", function() return require('refactoring').refactor('Inline Variable') end, { expr = true, desc = "Inline Variable" })

    vim.keymap.set({ "n", "x" }, "<leader>rbb", function() return require('refactoring').refactor('Extract Block') end, { expr = true, desc = "Extract Block" })
    vim.keymap.set({ "n", "x" }, "<leader>rbf", function() return require('refactoring').refactor('Extract Block To File') end, { expr = true, desc = "Extract Block To File" })
  end,
}


