local opt = vim.opt

-- tab/indent
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.wrap = false

-- search
opt.hlsearch = false
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- visual
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.signcolumn = "yes"

-- file system
opt.path:append('**')

-- etc
opt.encoding = "UTF-8"
opt.cmdheight = 1
opt.scrolloff = 10
-- opt.mouse:append("a")

opt.sessionoptions = 'curdir,folds,globals,help,tabpages,terminal,winsize'


-- text
vim.cmd([[autocmd BufEnter * set formatoptions-=cro]])

-- indent for file type
vim.cmd([[autocmd FileType php setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab]])
