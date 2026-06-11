return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        php = { "php-cs-fixer" },
      },
      formatters = {
        ["php-cs-fixer"] = {
          command = "php-cs-fixer",
          args = {
            "fix",
            "$FILENAME",
          },
          stdin = false
        },
      },
      notify_on_error = true,
      -- format_on_save = {
      -- 	timeout_ms = 500,
      -- 	lsp_format = "fallback",
      -- },
    })

    -- Alt+f 로 현재 버퍼 포맷.
    vim.keymap.set({ "n", "v" }, "<M-f>", function()
      require("conform").format({ async = true, lsp_format = "fallback" })
    end, { desc = "Format buffer (conform)" })
  end,
}
