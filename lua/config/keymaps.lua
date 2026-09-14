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

-- 날짜 추가
mapKey('<M-d>', '<C-r>=strftime("%Y-%m-%d")<CR>', 'i', { desc = "Insert today's date" })

-- 현재 버퍼의 파일 경로를 클립보드로 복사 (visual mode에서는 #L{line} 범위 추가)
local function copy_file_path(include_lines)
  if include_lines then
    -- Visual 모드를 먼저 빠져나와야 vim.notify 메시지가 "-- VISUAL --" 표시에 가려지지 않음
    vim.cmd('normal! \27') -- Escape key
  end
  local path = vim.fn.expand('%:p')
  if include_lines then
    local start_line = vim.fn.getpos("'<")[2]
    local end_line = vim.fn.getpos("'>")[2]
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
    if start_line == end_line then
      path = path .. '#L' .. start_line
    else
      path = path .. '#L' .. start_line .. '-L' .. end_line
    end
  end
  vim.fn.setreg('+', path)
  vim.notify('Copied path: ' .. path)
end

mapKey('<leader>cp', function() copy_file_path(false) end, 'n', { desc = "Copy current buffer's file path" })
mapKey('<leader>cp', function() copy_file_path(true) end, 'v', { desc = "Copy current buffer's file path with line range" })

