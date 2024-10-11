local opt = vim.opt

-- tab/indent
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.indentexpr = ""
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
-- opt.autochdir = true

-- etc
opt.encoding = "UTF-8"
opt.cmdheight = 1
opt.scrolloff = 10
opt.mouse = ""
-- opt.mouse:append("a")

-- tabby
opt.sessionoptions = 'curdir,folds,globals,help,tabpages,terminal,winsize'
