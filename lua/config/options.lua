local opt = vim.opt

-- tab/indent
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.indentexpr = ""
opt.wrap = true

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

-- wildmenu
opt.wildmenu = true
opt.wildoptions = "pum"
opt.pumheight = 15
opt.wildignore = "node_modules/**,.git/**,vendor/**,**/vendor/**,build/**,bin/**,*.dll,*.so*.o,*.min.*,*.map.*,*.dSYM"

-- etc
opt.encoding = "UTF-8"
opt.fileencoding="UTF-8"
opt.cmdheight = 1
opt.scrolloff = 10

-- tabby
opt.sessionoptions="buffers,curdir,folds,tabpages,winsize,winpos,terminal,localoptions"

-- file
opt.fixendofline = false

-- mouse
opt.mouse = "a"
opt.mousescroll = "ver:10,hor:6";

-- dictionary
-- opt.spell = true

-- shell (Windows: use PowerShell)
if vim.fn.has("win32") == 1 then
  local pwsh = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"
  opt.shell = pwsh
  opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
  opt.shellquote = ""
  opt.shellxquote = ""
  opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
  opt.shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
end

-- ripgrep
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --smart-case"
  -- opt.grepformat = "%f:%l:%c:%m"
end

-- opt.shada = "" -- ShaDa 저장 비활성화