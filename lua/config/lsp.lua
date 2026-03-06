-- Setup LSP servers
-- :help lsp-config
-- :checkhealth lsp

--[[
LSP 기본 설정시 참고 https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
LSP 설정법
1. mason ensured installed 에 추가.
2. nvim/lsp/lua/filetype.lua 로 파일 생성후 설정값 (table type) 리턴.
--]]
local lsp_configs = {}

for _, f in pairs(vim.api.nvim_get_runtime_file('lsp/*.lua', true)) do
  local server_name = vim.fn.fnamemodify(f, ':t:r')
  table.insert(lsp_configs, server_name)
end

vim.lsp.enable(lsp_configs)

vim.diagnostic.config({
    virtual_text = false, -- set to false to disable inline text
    signs = true,
    update_in_insert = false, -- set to true to update diagnostics in insert mode
    severity_sort = true,
    float = {
        source = "always",
    },
})

vim.keymap.set('n', 'gK', function()
  local new_config = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = 'Toggle diagnostic virtual_lines' })

vim.keymap.set('n', '<C-d>', vim.diagnostic.setloclist, { desc = 'Open diagnostic loclist' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action' })

vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
  end,
})
