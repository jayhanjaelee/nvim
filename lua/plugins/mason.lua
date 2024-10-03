local keyMapper = require("utils.keyMapper").mapKey

return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
  -- LSP
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"ts_ls",
					"clangd",
					"intelephense",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({})
			lspconfig.ts_ls.setup({})
			lspconfig.clangd.setup({})
			lspconfig.intelephense.setup({
				cmd = { "intelephense", "--stdio" },
				filetypes = "php",
				root_dir = lspconfig.util.root_pattern("composer.json", ".git", ".svn"),
			})

			keyMapper("K", vim.lsp.buf.hover)
			keyMapper("gd", vim.lsp.buf.definition)
			keyMapper("<leader>ca", vim.lsp.buf.code_action)
		end,
	},

  -- Formatter
	{
		"jay-babu/mason-null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"nvimtools/none-ls.nvim",
		},
    config = function() 
      require("mason-null-ls").setup({
        ensure_installed = {
          'stylua',
          'black',
          'php-cs-fixer'
        },
        automatic_installation = false,
        handlers = {},
      })
    end,
	},
}
