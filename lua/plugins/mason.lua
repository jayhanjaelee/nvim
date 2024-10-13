local mapKey = require("utils.keyMapper").mapKey
local custom_lsp_attach = function(client)
  vim.api.nvim_set_current_dir(client.config.root_dir)
  -- other stuff...
end

return {
  -- Mason
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
  -- LSPconfig
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
      local navic = require("nvim-navic")
      local result = lspconfig.util.root_pattern(
        ".svn", "composer.json", ".git"
      )

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

      -- lspconfig.phpactor.setup{
      --   root_dir = lspconfig.util.root_pattern(
      --     ".svn"
      --   ),
      -- }
      -- js & ts
			lspconfig.ts_ls.setup({})
      -- c
			lspconfig.clangd.setup({
        -- on_attach = on_attach
        -- on_attach = function(client, bufnr)
        --   require('nvim-navic').attach(client, bufnr)
        -- end
        -- cmd = { "--function-arg-placeholders" }
      })
      -- php
      lspconfig.intelephense.setup({
        cmd = { "intelephense", "--stdio" },
        filetypes = "php",
        single_file_support = false,
        root_dir = lspconfig.util.root_pattern(
          ".svn", "composer.json", ".git"
        ),
        -- on_attach = function(client, bufnr)
        --   navic.attach(client, bufnr)
        -- end
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

			mapKey("K", vim.lsp.buf.hover)
			mapKey("gd", vim.lsp.buf.definition)
			mapKey("<leader>ca", vim.lsp.buf.code_action)
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
