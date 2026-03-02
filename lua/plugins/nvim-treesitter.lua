return {
  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        matchup = {
          enable = true,
        },
        highlight = {
          enable = true,
          -- disable = function(lang, bufnr)
          --   return vim.api.nvim_buf_line_count(bufnr) > 5000
          -- end,
        },
        ensure_installed = {
          "php",
          "phpdoc",
          "c",
          "cpp",
          "bash",
          "lua",
          "python",
          "vim",
          "vimdoc",
          "query",
          "javascript",
          "typescript",
          "html",
          "css",
          "asm",
          "disassembly",
          "markdown",
          "rust",
          "sql",
          "make",
          "java",
          "tsx",
          "json",
          "xml",
          "go",
          "cmake",
          "make",
          "dockerfile",
          "http"
        },
        sync_install = false,
        indent = { enable = true },
        require("nvim-treesitter").statusline({})
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      vim.keymap.set("n", "[c", function()
        require("treesitter-context").go_to_context(vim.v.count1)
      end, { silent = true, desc = "Jump to context" })
    end
  },
  {
    'Wansmer/treesj',
    keys = {
      { '<leader>m', desc = "Toggle split/join" },
      -- { '<leader>j', desc = "Join code block" },
      -- { '<leader>s', desc = "Split code block" },
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
    config = function()
      require('treesj').setup({--[[ your config ]]})
    end,
  }
}
