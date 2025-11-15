return {
  "ray-x/lsp_signature.nvim",
  event = "VeryLazy",
  opts = {},
  config = function(_, opts)
    -- Configuration is done via LspAttach autocmd in lua/config/autocmd.lua
    -- to ensure it's properly attached to each LSP client
  end
}
