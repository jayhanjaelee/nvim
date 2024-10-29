local mapKey = require("utils.keyMapper").mapKey

-- Neotree toggle
mapKey('<leader>e', ':Neotree toggle<CR>')

-- pane navigation
mapKey('<C-h>', '<C-w>h') -- Left
mapKey('<C-j>', '<C-w>j') -- Down
mapKey('<C-k>', '<C-w>k') -- Up
mapKey('<C-l>', '<C-w>l') -- Right

-- pane resize
mapKey("<M-h>", ":vertical resize -2<cr>")
mapKey("<M-l>", ":vertical resize +2<cr>")
mapKey("<M-j>", ":horizontal resize -2<cr>")
mapKey("<M-k>", ":horizontal resize +2<cr>")

-- clear search hl
mapKey('<leader>h', ':nohlsearch<CR>')

-- indent
mapKey('<', '<gv', 'v')
mapKey('>', '>gv', 'v')

-- buffer
mapKey('<C-p>', ':bp<cr>')
mapKey('<C-n>', ':bn<cr>')
mapKey('<leader>dd', ':bd<cr>')
mapKey('<leader><S-d>', ':%bd|e#|bd#<cr>') -- delete other buffers
mapKey('<leader>l', ':ls<cr>')

-- tabpage
mapKey('<leader>t', ':tabnew %<cr>')
mapKey('<leader>w', ':tabclose<cr>')

-- zoom
-- mapKey('<C-w>z', '<C-w>_<C-w>|');

-- file
mapKey('<C-g>', '1<C-g>')
-- mapKey('<leader>r', ':browse oldfiles!<cr>')
