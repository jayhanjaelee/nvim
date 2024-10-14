local mapKey = require("utils.keyMapper").mapKey

-- hover
-- vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
--   vim.lsp.handlers.hover,
--   {border = 'rounded'}
-- )
-- vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
--   vim.lsp.handlers.signature_help,
--   {border = 'rounded'}
-- )
--
-- vim.diagnostic.config({
--   float = {
--     border = 'rounded',
--   },
-- })

-- Add border to the diagnostic popup window
vim.diagnostic.config({
    -- virtual_text = {
    --     prefix = '■ ', -- Could be '●', '▎', 'x', '■', , 
    -- },
    float = { border = border },
})

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

      vim.keymap.set('n', '[d', function() vim.diagnostic.goto_prev() end, opts)
      vim.keymap.set('n', ']d', function() vim.diagnostic.goto_next() end, opts)

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
			lspconfig.clangd.setup({})
      -- php
      lspconfig.intelephense.setup({
        cmd = { "intelephense", "--stdio" },
        filetypes = "php",
        root_dir = lspconfig.util.root_pattern(
          ".svn", "composer.json", ".git"
        ) or vim.fn.getcwd(),
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
