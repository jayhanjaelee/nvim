local jaylee = vim.api.nvim_create_augroup("jaylee", {
    clear = false
})

vim.api.nvim_create_autocmd({'BufWinEnter'}, {
  group = jaylee,
  desc = 'Restore cursor last position.',
  pattern = '*',
  command = 'silent! normal! g`"zv',
})

-- text format
vim.cmd([[autocmd BufNewFile,BufRead,BufWinEnter * set formatoptions-=c]])
vim.cmd([[autocmd BufNewFile,BufRead,BufWinEnter * set formatoptions-=r]])
vim.cmd([[autocmd BufNewFile,BufRead,BufWinEnter * set formatoptions-=o]])

-- indent for file type
vim.cmd([[autocmd FileType php setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab autoindent]])
vim.cmd([[autocmd FileType php setlocal iskeyword+=$]])
vim.cmd([[autocmd FileType javascript setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab autoindent]])
vim.cmd([[autocmd FileType html setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab autoindent]])
vim.cmd([[autocmd FileType mustache setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab autoindent]])
vim.cmd([[autocmd FileType css setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab autoindent]])

-- close quickfix window after opening it.
vim.cmd([[autocmd FileType qf nnoremap <silent> <buffer> <CR> <CR>:cclose<CR>]])

-- large file loading performance
local function disable_syntax_treesitter()
    print("Big file, disabling syntax, treesitter and folding")
    if vim.fn.exists(':TSBufDisable') == 2 then
        vim.cmd('TSBufDisable autotag')
        vim.cmd('TSBufDisable highlight')
        -- add more treesitter-related disables here if needed
    end

    vim.o.foldmethod = 'manual'
    vim.cmd('syntax clear')
    vim.cmd('syntax off')  -- 'syntax off' should be used to turn off syntax highlighting
    vim.cmd('filetype off')
    vim.o.undofile = false
    vim.o.swapfile = false
    vim.o.loadplugins = false
end

local function check_file_size()
    local max_size = 512 * 1024 -- 512 KB
    local file = vim.fn.expand("%")
    if vim.fn.getfsize(file) > max_size then
        disable_syntax_treesitter()
    end
end

-- Disalbe syntax for huge size file.
-- vim.api.nvim_create_augroup("BigFileDisable", { clear = true })
-- vim.api.nvim_create_autocmd({ "BufReadPre", "FileReadPre" }, {
--     group = "BigFileDisable",
--     callback = check_file_size,
-- })

-- use system clipboard by default
if vim.fn.has('clipboard') == 1 then
  -- Use the system clipboard for yanking and pasting
  vim.opt.clipboard = 'unnamedplus'  -- Use the + register for the clipboard
end

-- WSL yank support
local clip = '/mnt/c/Windows/System32/clip.exe'  -- change this path according to your mount point

if vim.fn.executable(clip) == 1 then
    vim.api.nvim_exec([[
        augroup WSLYank
            autocmd!
            autocmd TextYankPost * if v:event.operator ==# 'y' | call system(']] .. clip .. [[' , @0) | endif
        augroup END
    ]], false)
end
