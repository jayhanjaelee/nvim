return {
  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
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
          "html",
          "css",
          "asm",
          "disassembly",
          "markdown",
          "rust",
          "sql",
          "make",
          "java"
        },
        sync_install = false,
        indent = { enable = true },
        require("nvim-treesitter").statusline({})
      })
    end,
  },
}
