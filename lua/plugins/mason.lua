-- https://mason-registry.dev/registry/list
local PACKAGES = {
	-- LSP
  "clangd",
  "intelephense",
	"css_variables",
	"cssls",
	"cssmodules_ls",
	"dockerls",
	"eslint",
	"html",
	"jsonls",
	"lua_ls",
	"pyright",
	"tailwindcss",
	"ts_query_ls",
	"ts_ls",
	"yamlls",
	-- Format
	-- "black",
	-- "prettierd",
	-- "stylua",
	-- Lint
}

return {
  {
    "mason-org/mason.nvim",
    opts = {}
  },
  {
    -- Install and upgrade 3rd-party tools managed by mason.nvim
    -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
    -- https://github.com/ruicsh/nvim-config/blob/main/lua/lib/env.lua
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    enabled = not os.getenv("NVIM_GIT_DIFF"),
    opts = function()
      local packages = vim.tbl_deep_extend("force", {}, PACKAGES)

      return {
        ensure_installed = packages,
        integrations = {
          ["mason-lspconfig"] = true,
          ["mason-null-ls"] = false,
          ["mason-nvim-dap"] = false,
        },
      }
    end,

    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
  },
}
