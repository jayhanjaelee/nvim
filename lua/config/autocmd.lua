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
vim.cmd([[autocmd BufNewFile,BufRead,BufWinEnter * set formatoptions+=c]])
vim.cmd([[autocmd BufNewFile,BufRead,BufWinEnter * set formatoptions+=r]])
vim.cmd([[autocmd BufNewFile,BufRead,BufWinEnter * set formatoptions-=o]])

-- indent for file type
vim.cmd([[autocmd FileType php setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab autoindent]])
vim.cmd([[autocmd FileType php setlocal iskeyword+=$]])
vim.cmd([[autocmd FileType html setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab autoindent]])
vim.cmd([[autocmd FileType mustache setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab autoindent]])
vim.cmd([[autocmd FileType css setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab autoindent]])
vim.cmd([[autocmd FileType javascript setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab autoindent]])
vim.cmd([[autocmd FileType typescript setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab autoindent]])
vim.cmd([[autocmd FileType javascriptreact setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab autoindent]])
vim.cmd([[autocmd FileType typescriptreact setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab autoindent]])
vim.cmd([[autocmd FileType rust setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab autoindent]])
vim.cmd([[autocmd FileType c setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab autoindent]])
vim.cmd([[autocmd FileType cpp setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab autoindent]])

-- Enable the built-in auto-reload option
vim.opt.autoread = true
-- -- Automatically check for changes when Neovim regains focus, a buffer is entered,
-- -- or the cursor is idle, provided not in command mode
-- vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "VimResume", "CursorHold", "CursorHoldI" }, {
--   group = vim.api.nvim_create_augroup("CheckForExternalChanges", { clear = true }),
--   callback = function()
--     if vim.fn.mode() ~= 'c' then -- Check if not in command mode
--       vim.cmd("checktime")
--     end
--   end,
-- })

vim.api.nvim_create_autocmd("FileType", {
  group = jaylee,
  pattern = { "c", "cpp" },
  callback = function()
    vim.keymap.set("n", "gh", "<cmd>LspClangdSwitchSourceHeader<CR>", { buffer = true, desc = "Switch Source/Header" })
  end,
})

-- close quickfix window after opening it.
-- vim.cmd([[autocmd FileType qf nnoremap <silent> <buffer> <CR> <CR>:cclose<CR>]])

-- set quickfix window height to 30% of screen height
vim.api.nvim_create_autocmd("FileType", {
  group = jaylee,
  pattern = "qf",
  callback = function()
    local qf_height = math.floor(vim.o.lines * 0.3)
    vim.cmd("resize " .. qf_height)
  end,
})

-- use system clipboard by default
if vim.fn.has('clipboard') == 1 then
  -- Use the system clipboard for yanking and pasting
  vim.opt.clipboard = 'unnamedplus'  -- Use the + register for the clipboard
end

-- large file loading performance
-- local function disable_syntax_treesitter()
--     print("Big file, disabling syntax, treesitter and folding")
--     if vim.fn.exists(':TSBufDisable') == 2 then
--         vim.cmd('TSBufDisable autotag')
--         vim.cmd('TSBufDisable highlight')
--         -- add more treesitter-related disables here if needed
--     end
--
--     vim.o.foldmethod = 'manual'
--     vim.cmd('syntax clear')
--     vim.cmd('syntax off')  -- 'syntax off' should be used to turn off syntax highlighting
--     vim.cmd('filetype off')
--     vim.o.undofile = false
--     vim.o.swapfile = false
--     vim.o.loadplugins = false
-- end
--
-- local function check_file_size()
--     local max_size = 512 * 1024 -- 512 KB
--     local file = vim.fn.expand("%")
--     if vim.fn.getfsize(file) > max_size then
--         disable_syntax_treesitter()
--     end
-- end

-- Disalbe syntax for huge size file.
-- vim.api.nvim_create_augroup("BigFileDisable", { clear = true })
-- vim.api.nvim_create_autocmd({ "BufReadPre", "FileReadPre" }, {
--     group = "BigFileDisable",
--     callback = check_file_size,
-- })
