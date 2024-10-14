return {
 'kevinhwang91/nvim-ufo',
  dependencies = 'kevinhwang91/promise-async',
  config = function()
    vim.o.foldcolumn = '0' -- '0' is not bad
    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true
    }

    local lspconfig = require("lspconfig")
    local language_servers = lspconfig.util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
    for _, ls in ipairs(language_servers) do
      lspconfig[ls].setup({
        capabilities = capabilities,
        root_dir = function(pattern)
          local cwd = vim.uv.cwd()
          local root = lspconfig.util.root_pattern('composer.json', '.git', '.svn', 'index.php', 'lib.php', 'config.php')(pattern)

          -- prefer cwd if root is a descendant
          return lspconfig.util.path.is_descendant(cwd, root) and cwd or root
        end,
      })
    end
    require('ufo').setup()
  end,
}
