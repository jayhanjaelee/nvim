local mapKey = require("utils.keyMapper").mapKey

vim.lsp.handlers['workspace/diagnostic/refresh'] = function(_, _, ctx)
  local ns = vim.lsp.diagnostic.get_namespace(ctx.client_id)
  local bufnr = vim.api.nvim_get_current_buf()
  vim.diagnostic.reset(ns, bufnr)
  return true
end

-- virtual text
vim.diagnostic.config({
  virtual_text = false,
})

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
          -- "asm_lsp", -- assembly
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
        cmd = { 'intelephense', '--stdio' },
        filetypes = { 'php' },
        root_dir = function(pattern)
          local cwd = vim.uv.cwd()
          local root = lspconfig.util.root_pattern('composer.json', '.git', '.svn')(pattern)

          -- prefer cwd if root is a descendant
          return lspconfig.util.path.is_descendant(cwd, root) and cwd or root
        end,
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
