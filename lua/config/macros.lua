---------------------
--- CUSTOM MACROS ---
---------------------
local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)

-- c
vim.api.nvim_create_augroup("CLogMacro", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "CLogMacro",
  pattern = { "c" },
  callback = function()
    vim.fn.setreg("e", "yoprintf(\"[DBG] " .. esc .. "pa: %s\\n\", " .. esc .. "pa);" .. esc);
    end,
})

-- php
vim.api.nvim_create_augroup("PHPLogMacro", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "PHPLogMacro",
  pattern = { "php" },
  callback = function()
    vim.fn.setreg("e", "yoerror_log('[DBG] ".. esc .."pa:'.".. esc.. "pa);".. esc)
  end,
})


-- javascript
vim.api.nvim_create_augroup("JavascriptMacro", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "JavascriptMacro",
  pattern = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  callback = function()
    vim.fn.setreg("e", "yoconsole.log('[DBG] " ..  esc .. "pa:', " .. esc .. "pa);" .. esc)
    end,
})
