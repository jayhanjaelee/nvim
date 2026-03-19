-- php
local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  -- measure execution time
  s('calc_time', {
    t({'$startTime = microtime(true);', ''}),
    t({'// do something.', ''}),
    t({'$endTime = microtime(true);', ''}),
    t({'$executionTime = $endTime - $startTime;', ''}),
    t({"$formattedTime = number_format($executionTime, 1, '.', '');", ''}),
    t({'error_log("Execution time: " . $formattedTime . " seconds");', ''}),
  }),

  -- Moodle 코스 페이지 초기화 (인터렉티브)
  s('mdl_init', {
    t({ 'use local_ubion\\course\\Course;',
        'use local_manager\\haksa\\api\\HaksaAPI;',
        '',
        '$courseid = required_param(\''}),
    i(1, 'id'),
    t({ '\', PARAM_INT);',
        '',
        '// 강좌번호는 1보다 커야됨.',
        'if ($courseid <= SITEID) {',
        '    redirect($CFG->wwwroot);',
        '}',
        '',
        '$CCourse = Course::getInstance();',
        '',
        '$pagetitle = get_string(\''}),
    i(2, 'syllabus'),
    t({ '\', \''}),
    i(3, 'local_ubion'),
    t({ '\');',
        '',
        '$PAGE->set_url(\''}),
    i(4, '/local/ubion/course/syllabus.php'),
    t({ '\', [',
        '    \'id\' => $courseid',
        ']);',
        '',
        '$course = $CCourse->getCourse($courseid);',
        '$context = context_course::instance($course->id);',
        '$courseUbion = $CCourse->getUbion($course->id);',
        '',
        '$PAGE->set_context($context);',
        '$PAGE->set_course($course);',
        'require_login($course);',
        '',
        '$PAGE->set_title("$course->shortname: " . $pagetitle);',
        '$PAGE->set_heading($course->fullname);'}),
  }),

  -- Moodle AMD 호출
  s('mdl_amd', {
    t('$PAGE->requires->js_call_amd(\''),
    i(1, '{module/name}'),
    t('\', \''),
    i(2, '{function_name}'),
    t('\');'),
  }),

  -- Moodle 페이지 렌더링 (header, heading, footer)
  s('mdl_page', {
    t('echo $OUTPUT->header();'),
    t({ '', '', 'echo $OUTPUT->heading(' }),
    i(1, '$pagetitle'),
    t({ ');', '', '' }),
    i(2),
    t({ '', '', 'echo $OUTPUT->footer();' }),
  }),

  s('mdl_str', {
    t({'$PAGE->requires->strings_for_js([', '\t'}),
    i(1, "'string'"), t({'', ''}),
    t('], '), i(2, '$plugin_name'), t(');')
  }),

  -- PHP try-catch 블록
  s('php_try', {
    t({ 'try {',
        '  ' }),
    i(1),
    t({ '',
        '} catch (Exception $e) {',
        '  ' }),
    i(2, 'echo $e->getMessage();'),
    t({ '',
        '}' }),
  }),

  -- PHP foreach 루프
  s('php_foreach', {
    t('foreach ($'),
    i(1, 'array'),
    t(' as $'),
    i(2, 'key'),
    t(' => $'),
    i(3, 'value'),
    t({ ') {', '  ' }),
    i(4),
    t({ '', '}' }),
  }),

  -- PHP 클래스 정의
  s('php_class', {
    t('class '), i(1, 'ClassName'), t({ ' {', '  ' }),
    t('public function __construct() {'),
    t({ '', '    ' }),
    i(2),
    t({ '', '  }', '', '}' }),
  }),

  -- PHP 함수 정의
  s('php_func', {
    t('public function '), i(1, 'functionName'), t('('),
    i(2, '$param'),
    t({ ') {', '  ' }),
    i(3),
    t({ '', '  return ' }),
    i(4, '$result'),
    t({ ';', '}' }),
  }),

  -- PHP if-else 블록
  s('php_if', {
    t('if ('), i(1, '$condition'), t({ ') {', '  ' }),
    i(2),
    t({ '', '} else {', '  ' }),
    i(3),
    t({ '', '}' }),
  }),

}
