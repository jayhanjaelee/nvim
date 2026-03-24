-- React (JSX) 스니펫
local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  -- AJAX 다운로드 버튼 핸들러
  s('ajax_download', {
    t({
      "$(\".list button.",
    }),
    i(1, 'download-excel'),
    t({
      "\").click(function () {",
      "\t\t\tlet year = $(this).attr('data-",
    }),
    i(2, 'year'),
    t({
      "');",
      "\t\t\tlet semester_code = $(this).attr('data-",
    }),
    i(3, 'semester_code'),
    t({
      "');",
      "",
      "\t\t\tlet requestBody = {",
      "\t\t\t\t'type': '",
    }),
    i(4, 'download_excel'),
    t({
      "',",
      "\t\t\t\t'returnurl': '<?php echo $CFG->wwwroot . '",
    }),
    i(5, ""),
    t({
      "'; ?>',",
      "\t\t\t\t'year': year,",
      "\t\t\t\t'semester_code': semester_code,",
      "\t\t\t};",
      "",
      "\t\t\t$.ajax({",
      "\t\t\t\ttype: 'post',",
      "\t\t\t\turl: '<?php echo $CFG->wwwroot . '",
    }),
    i(6, ""),
    t({
      "'; ?>',",
      "\t\t\t\tdata: requestBody,",
      "\t\t\t\tdataType: 'application/json',",
      "\t\t\t\tsuccess: function(data) {",
      "\t\t\t\t\t",
    }),
    i(7, '// do something'),
    t({
      "",
      "\t\t\t\t},",
      "\t\t\t\terror: function(error) {",
      "\t\t\t\t\t",
    }),
    i(8, '// do something'),
    t({
      "",
      "\t\t\t\t}",
      "\t\t\t});",
      "",
      "\t\t\treturn false;",
      "\t\t});",
    }),
  }),

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
