-- React (JSX) 스니펫
local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  -- useRef
  s('useref', {
    t('const '), i(1, 'ref'), t(' = useRef('), i(2, 'null'), t(')'),
  }),
  s('rafce', {
    t({ "const " }), i(1, 'MyComponent'), t({ " = () => {", "  return (", "    <div>" }),
    i(2, 'content'),
    t({ "</div>", "  )", "}", "", "export default " }), rep(1),
  })
}
