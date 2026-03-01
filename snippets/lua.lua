-- Lua 파일에서만 사용 가능한 스니펫
local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  -- 예시: 함수 정의
  s('fn', {
    t('function '), i(1, 'name'), t('('), i(2), t({ ')', '  ' }),
    i(3),
    t({ '', 'end' }),
  }),

  -- 예시: local 함수
  s('lfn', {
    t('local function '), i(1, 'name'), t('('), i(2), t({ ')', '  ' }),
    i(3),
    t({ '', 'end' }),
  }),
}
