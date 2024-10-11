local keyMapper = require("utils.keyMapper").mapKey
local custom_lsp_attach = function(client)
  vim.api.nvim_set_current_dir(client.config.root_dir)
  -- other stuff...
end

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
					"lua_ls", -- php
					"clangd", -- c
          "asm_lsp", -- assembly
					"ts_ls", -- javascript & typescript
					"intelephense", -- php
          "pylsp", -- python
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
      -- lua
			lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = {'vim'}
            }
          }
        }
      })
      -- js & ts
			lspconfig.ts_ls.setup({})
      -- c
			lspconfig.clangd.setup({
        -- on_attach = on_attach
        on_attach = function(client, bufnr)
          require('nvim-navic').attach(client, bufnr)
        end
        -- cmd = { "--function-arg-placeholders" }
      })
      -- php
      lspconfig.intelephense.setup({
        cmd = { "intelephense", "--stdio" },
        filetypes = "php",
        root_dir = lspconfig.util.root_pattern(
          "composer.json", ".git", ".svn"
        )
      })
      -- assembly
      lspconfig.asm_lsp.setup{
        cmd = {"asm-lsp"},
        filetypes = {"asm","vmasm","s"},
        opts = {
          -- compiler = "gcc"
          diagnostics = false,
          default_diagnostics = false
        }
      }
      -- python
      lspconfig.pylsp.setup{}

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
