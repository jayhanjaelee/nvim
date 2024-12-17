return {
  "ray-x/lsp_signature.nvim",
  event = "InsertEnter",
  opts = {},
  config = function(_, opts) require'lsp_signature'.setup({
    doc_lines = 99,
    max_width = 99,
  }) end
}
