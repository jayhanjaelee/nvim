-- 모든 파일 타입에서 사용 가능한 스니펫
local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

return {
  -- 예시: 현재 날짜 삽입
  s('date', {
    f(function() return os.date('%Y-%m-%d') end),
  }),

  -- 예시: TODO 주석
  s('todo', {
    t('// TODO: '), i(1, 'description'),
  }),

  s('dbg', {
    t('// DEBUG: '), i(1, 'description'),
  }),
}
