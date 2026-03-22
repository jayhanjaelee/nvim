local mapKey = require("utils.keymapper").mapKey

-- Neotree toggle
mapKey('<leader>e', ':Neotree toggle<CR>', 'n', { desc = "Toggle Neotree" })

-- pane navigation
mapKey('<C-h>', '<C-w>h', 'n', { desc = "Navigate to left pane" }) -- Left
mapKey('<C-j>', '<C-w>j', 'n', { desc = "Navigate to down pane" }) -- Down
mapKey('<C-k>', '<C-w>k', 'n', { desc = "Navigate to up pane" }) -- Up
mapKey('<C-l>', '<C-w>l', 'n', { desc = "Navigate to right pane" }) -- Right

-- pane resize
mapKey("<M-h>", ":vertical resize -2<cr>", 'n', { desc = "Decrease window width" })
mapKey("<M-l>", ":vertical resize +2<cr>", 'n', { desc = "Increase window width" })
mapKey("<M-j>", ":horizontal resize -2<cr>", 'n', { desc = "Decrease window height" })
mapKey("<M-k>", ":horizontal resize +2<cr>", 'n', { desc = "Increase window height" })

-- clear search hl
mapKey('<leader>h', ':nohlsearch<CR>', 'n', { desc = "Clear search highlight" })

-- indent
-- mapKey('<', '<gv', 'v', { desc = "Indent left and reselect" })
-- mapKey('>', '>gv', 'v', { desc = "Indent right and reselect" })

-- buffer
-- mapKey('<C-j>', ':bp<cr>')
-- mapKey('<C-k>', ':bn<cr>')
mapKey('<leader>dd', ':bd<cr>')
mapKey('<leader><S-d>', ':%bd|e#|bd#<cr>') -- delete other buffers
-- mapKey('<leader>l', ':ls<cr>')

-- tabpage
mapKey('<leader>t', ':tabnew %<cr>', 'n', { desc = "Open current buffer in new tab" })
mapKey('<leader>w', ':tabclose<cr>', 'n', { desc = "Close current tab" })
mapKey('<leader>W', ':tabonly<cr>', 'n', { desc = "tab only" })

-- zoom (using plugin, so comment it)
-- mapKey('<C-w>z', '<C-w>_<C-w>|');

-- terminal mode
-- mapKey('<Esc>', '<C-\\><C-n>', 't', { desc = "Exit terminal mode" })

-- file
mapKey('<C-g>', '1<C-g>', 'n', { desc = "Show full file path" })
-- mapKey('<leader>r', ':luafile ~/.config/nvim/init.lua<cr>', 'n', { desc = "Reload Neovim config" })
-- mapKey('<leader>r', ':browse oldfiles!<cr>')

-- LSP things
-- mapKey('<leader>ca', vim.lsp.buf.code_action)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('HJLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Go to definition
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    mapKey("gd", vim.lsp.buf.definition, 'n', { buffer = ev.buf, desc = "Go to Definition" })
    -- Go to declaration
    mapKey("gD", vim.lsp.buf.declaration, 'n', { buffer = ev.buf, desc = "Go to Declaration" })
    -- Show hover information
    mapKey("K", vim.lsp.buf.hover, 'n', { buffer = ev.buf, desc = "Hover" })
  end,
})

-- quickfix list
local function toggle_quickfix()
  -- Check if the quickfix window is already open
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      vim.cmd.cclose()
      return
    end
  end

  -- If not open, open it (provided there are items in the list)
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd.copen()
  end
end

-- map the function to a key, for example, <Leader>q
mapKey('<leader>q', toggle_quickfix, 'n', { desc = "Toggle Quickfix Window" })
-- vim.keymap.set('n', '<leader>q', toggle_quickfix, { desc = "Toggle Quickfix Window" })
