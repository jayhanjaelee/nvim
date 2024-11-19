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
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- visual
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.list = false
opt.listchars = {
    -- space = "",    -- Character for spaces
    tab = " ",       -- Character for tabs
    eol = "󰌑",        -- Character for end of line
    trail = "󱁐",      -- Character for trailing spaces
    extends = ">",    -- Character for overflows to the right
    precedes = "<"    -- Character for overflows to the left
}
opt.cmdwinheight = 10
opt.eol = true
opt.fixeol = true

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
opt.sessionoptions="buffers,curdir,folds,tabpages,winsize,winpos,terminal,localoptions"
