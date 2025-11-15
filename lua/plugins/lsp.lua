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
          "emmet_ls", -- emmet
          "rust_analyzer", --rust
          "cssls" -- css
				},
			})
		end,
	},
  -- DAP
  {
    "jay-babu/mason-nvim-dap.nvim",
    config = function() 
      require("mason-nvim-dap").setup({
        ensure_installed = {
          "codelldb", -- rust
          "vscode-js-debug"
        }
      })
    end,
  },
  -- LSPconfig
	{
		"neovim/nvim-lspconfig",
    config = function()
      local navic = require("nvim-navic")

      -- Setup capabilities with completion and folding support
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- Add nvim-cmp capabilities if available
      local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
      if has_cmp then
        capabilities = vim.tbl_deep_extend('force', capabilities, cmp_nvim_lsp.default_capabilities())
      end

      -- Add folding capabilities for nvim-ufo
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }

      vim.keymap.set('n', '[d', function() vim.diagnostic.goto_prev() end, opts)
      vim.keymap.set('n', ']d', function() vim.diagnostic.goto_next() end, opts)

      -- Helper function to find root directory
      local function find_root(patterns)
        return function(filename)
          local cwd = vim.uv.cwd()
          local root = vim.fs.root(filename, patterns)
          -- prefer cwd if root is a descendant
          if root and cwd and vim.startswith(vim.fs.normalize(cwd), vim.fs.normalize(root)) then
            return cwd
          end
          return root or cwd
        end
      end

      -- lua
      vim.lsp.config('lua_ls', {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = {'vim'}
            }
          }
        }
      })

      -- cssls
      vim.lsp.config('cssls', {
        capabilities = capabilities,
        filetypes = { 'html', 'css', 'scss', 'php' }
      })

      -- js & ts
      vim.lsp.config('ts_ls', {
        capabilities = capabilities,
      })

      -- c
      vim.lsp.config('clangd', {
        capabilities = capabilities,
      })

      -- php
      vim.lsp.config('intelephense', {
        capabilities = capabilities,
        cmd = { 'intelephense', '--stdio' },
        filetypes = { 'php' },
        root_dir = find_root({'composer.json', '.git', '.svn'}),
        on_attach = function(client, bufnr)
          if client.server_capabilities.documentSymbolProvider then
            navic.attach(client, bufnr)
          end
        end,
      })

      -- assembly
      vim.lsp.config('asm_lsp', {
        capabilities = capabilities,
        cmd = {"asm-lsp"},
        filetypes = {"asm","vmasm","s"},
        opts = {
          -- compiler = "gcc"
          diagnostics = false,
          default_diagnostics = false
        }
      })

      -- python
      vim.lsp.config('pylsp', {
        capabilities = capabilities,
      })

      -- emmet
      vim.lsp.config('emmet_ls', {
        -- on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "svelte", "pug", "typescriptreact", "vue" },
        init_options = {
          html = {
            options = {
              -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
              ["bem.enabled"] = true,
            },
          },
        }
      })

      -- Enable all configured LSP servers
      vim.lsp.enable({'lua_ls', 'cssls', 'ts_ls', 'clangd', 'intelephense', 'asm_lsp', 'pylsp', 'emmet_ls'})

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
      -- require("mason-null-ls").setup({
      --   ensure_installed = {
      --     'stylua',
      --     'black',
      --     'php-cs-fixer'
      --   },
      --   automatic_installation = false,
      --   handlers = {},
      -- })
    end,
	},
}
