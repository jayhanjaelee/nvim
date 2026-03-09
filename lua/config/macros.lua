---------------------
--- CUSTOM MACROS ---
---------------------
--[[
- FileType: 파일 타입이 설정될 때 발생 (파일을 열
 때 주로 실행)
- BufEnter: 버퍼가 활성화될 때 발생 (파일 열기,  
pane 이동, 탭 전환 등)                         

Neovim에서 제공하는 다른 주요 이벤트들:
- WinEnter: 윈도우가 활성화될 때
- BufRead: 버퍼 읽기 완료 시
- BufWrite: 버퍼 저장 전
- CursorMoved: 커서 이동 시
--]]
local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)

-- c
vim.api.nvim_create_augroup("CLogMacro", { clear = true })
local c_macro = function()
  vim.fn.setreg("e", "")
  vim.fn.setreg("e", "yoprintf(\"[DBG] " .. esc .. "pa: %s\\n\", " .. esc .. "pa);" .. esc);
end
-- FileType은 파일타입으로
vim.api.nvim_create_autocmd("FileType", {
  group = "CLogMacro",
  pattern = { "c" },
  callback = c_macro,
})
-- BufEnter는 파일 확장자 패턴으로
vim.api.nvim_create_autocmd("BufEnter", {
  group = "CLogMacro",
  pattern = { "*.c" },
  callback = c_macro,
})

-- php
vim.api.nvim_create_augroup("PHPLogMacro", { clear = true })
local php_macro = function()
  vim.fn.setreg("e", "")
  vim.fn.setreg("e", "yoerror_log('[DBG] ".. esc .."pa:'.".. esc.. "pa);".. esc)
  vim.fn.setreg("w", "")
  vim.fn.setreg("w", "yoerror_log('[DBG] " .. esc .. "pa:'.print_r(" .. esc .. "pa, true));" .. esc)
end
vim.api.nvim_create_autocmd("FileType", {
  group = "PHPLogMacro",
  pattern = { "php" },
  callback = php_macro,
})
vim.api.nvim_create_autocmd("BufEnter", {
  group = "PHPLogMacro",
  pattern = { "*.php" },
  callback = php_macro,
})


-- javascript
vim.api.nvim_create_augroup("JavascriptMacro", { clear = true })
local js_macro = function()
  vim.fn.setreg("e", "")
  vim.fn.setreg("e", "yoconsole.log('[DBG] " ..  esc .. "pa:', " .. esc .. "pa);" .. esc)
end
vim.api.nvim_create_autocmd("FileType", {
  group = "JavascriptMacro",
  pattern = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  callback = js_macro,
})
vim.api.nvim_create_autocmd("BufEnter", {
  group = "JavascriptMacro",
  pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
  callback = js_macro,
})
