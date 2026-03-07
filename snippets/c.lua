-- c
local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s('readfile', {
    t('FILE *file = fopen('),
    i(1, '"filename.txt"'),
    t(' ,'),
    i(2, '"r"'),
    t({');', ''}),
    t({
      'char *line = NULL;',
      'size_t linecap = 0;',
      'ssize_t linelen;',
      'size_t total_fielsize = 0;',
      'while ((linelen = getline(&line, &linecap, file)) > 0) {',
      '\tprintf("%s", line);',
      '\ttotal_fielsize += linelen;',
      '}'
    }),
  });
}
