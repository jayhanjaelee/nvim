-- php
local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {

  s('mdl_require_ubion', {
    t("require_once $CFG->dirroot.'/local/ubion/library/"), i(1, "user/lib.php"), t("';")
  }),

  s('mdl_moodle_internal', {
    t("defined('MOODLE_INTERNAL') || die();")
  }),

  s('mdl_sql_like', {
    t({"$where[] = $DB->sql_like('LOWER('.$fullname.')', ':keyword');"}, {}),
    t({"$param['keyword'] = '%'.strtolower($keyword).'%';"}, {})
  }),

  -- render template
  s('render_mustache_template', {
    t({"echo $OUTPUT->header();", ""}),
    t({"echo $OUTPUT->render_from_template("}),
    i(1, "'local_manager/hello/index',"),
    t({"$ctx);", ""}),
    t({"echo $OUTPUT->footer();", ""}),
  }),

  -- curl
  s('curl', {
    t({"$ch = curl_init();", ""}),
    t({"curl_setopt($ch, CURLOPT_URL, $url);", ""}),
    t({"curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);", ""}),
    t({"curl_setopt($ch, CURLOPT_TIMEOUT, 5);   // timeout은 5초로 설정.", ""}),
    t({"curl_setopt($ch, CURLOPT_POST, true);", ""}),
    t({"curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($json));", ""}),
    t({"curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);", ""}),
    t({"curl_exec($ch);", ""}),
    t({"if (curl_errno($ch)) {", ""}),
    t({"\terror_log(print_r(curl_error($ch), true));", ""}),
    t({"}", ""}),
    t({"curl_close($ch);", ""}),
  }),

  -- 
  s('mdl_add_setting', {
    t({"$temp = new admin_settingpage($pluginname . '_facetoface', get_string('setting_title_facetoface', $pluginname));", ''}),
    t({"$name = $pluginname . '/isFacetoface';", ''}),
    t({"$title = get_string('setting_is_facetoface', $pluginname);", ''}),
    t({"$description = get_string('setting_is_facetoface_help', $pluginname);", ''}),
    t({"$default = 1;", ''}),
    t({"$setting = new admin_setting_configcheckbox($name, $title, $description, $default);", ''}),
  }),
      
  s('mdl_get_course_format', {
    t({'$course_format = course_get_format($id);', ''}),
    t({'$course = $course_format->get_course();', ''}),
  }),

  s('mdl_get_course_context', {
    t({'$course_context = context_course::instance($course->id);', ''})
  }),

  s('mdl_create_event', {
    t({
      "$params = array(",
			"\t'context' => context_course::instance($courseid),",
			"\t'objectid' => $week_add->id",
		  '); ',
      '$event = \\local_ubattendance\\event\\week_created::create($params);',
      '$event->add_record_snapshot(\'local_ubattendance\', $week_add);',
      '$event->trigger();'
    })
  }),

  s('mdl_cache', {
    t({"$cache = cache::make('"}), i(1, 'local_ubion'), t({"', '"}), i(2, 'current_semester'), t({"');", ''}),
    t({'$current_semester = $cache->get(\''}), i(3, 'current_semester'), t({'\');	', ''}),
    t({"$cache->set('"}), i(4, 'current_semester'), t({"', "}), i(5, '$current_semester'), t({");"})
  }),

  -- measure execution time
  s('calc_time', {
    t({'$startTime = microtime(true);', ''}),
    t({'// do something.', ''}),
    t({'$endTime = microtime(true);', ''}),
    t({'$executionTime = $endTime - $startTime;', ''}),
    t({"$formattedTime = number_format($executionTime, 1, '.', '');", ''}),
    t({'error_log("Execution time: " . $formattedTime . " seconds");', ''}),
  }),

  s('mdl_sql_get_field', {
    t({'$sql = "SELECT ', ''}),
    t({'\t'}),
    i(1, 'course_code'),
    t({'', ''}),
    t({'FROM {course} c', ''}),
    t({'JOIN {course_ubion} cu', ''}),
    t({'ON c.id = cu.course', ''}),
    t({'WHERE ', ''}),
    i(2, 'c.fullname'),
    t({' = '}),
    i(3, ':fullname'),
    t({'";', ''}),
    t({'$params = [', ''}),
    t({"\t"}),
    i(4, 'fullname'),
    t(" => "),
    i(5, '$keyword'),
    t({'', ''}),
    t({']', ''}),
    i(6, '$course_code'),
    t({' = $DB->get_field_sql($sql, $params);', ''}),
  });

  s('mdl_sql_get_records', {
    t({'$sql = "SELECT ', ''}),
    t({'\t'}),
    i(1, '*'),
    t({'', ''}),
    t({'FROM {course} c', ''}),
    t({'JOIN {course_ubion} cu', ''}),
    t({'ON c.id = cu.course', ''}),
    t({'WHERE ', ''}),
    i(2, 'c.id'),
    t({' = '}),
    i(3, ':id'),
    t({'";', ''}),
    t({'$params = [', ''}),
    t({"\t"}),
    i(4, "'id'"),
    t(" => "),
    i(5, '$courseid'),
    t({'', ''}),
    t({'];', ''}),
    i(6, '$course'),
    t({' = $DB->get_records_sql($sql, $params);', ''}),
  });


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

  s('set_limit', {
    t({'ini_set("memory_limit", -1); // set unlimited memory storage.', ''}),
    t({'set_time_limit(0); // set unlimited execution time.', ''})
  }),

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

  s('base_dto', {
    t({'<?php', ''}),
    t({'abstract class BaseDTO {', ''}),
    t({'\tpublic static function fromStdClass($obj): self {', ''}),
    t({'\t\t$dto = new static();', ''}),
    t({'\t\tforeach ((array)$obj as $key => $value) {', ''}),
    t({'\t\t\tif (property_exists($dto, $key)) {', ''}),
    t({'\t\t\t\t$dto->$key = $value;', ''}),
    t({'\t\t\t}', ''}),
    t({'\t\t}', ''}),
    t({'\t\treturn $dto;', ''}),
    t({'\t}', ''}),
    t({'}', ''}),
  }),

  s('set_dto', {
    t({'if ($dtoClass) {', ''}),
    t({'\treturn array_map(function($record) use ($dtoClass) {', ''}),
    t({'\t\treturn $dtoClass::fromStdClass($record);', ''}),
    t({'\t}, $records);', ''}),
    t({'}', ''}),
  }),

  s('singleton', {
    t({'private static $instance;', ''}),
    t({'', ''}),
    t({'public static function getInstance() {', ''}),
    t({'\tif (!isset(self::$instance)) {', ''}),
    t({'\t\t$c = __CLASS__;', ''}),
    t({'\t\tself::$instance = new $c;', ''}),
    t({'\t}', ''}),
    t({'\treturn self::$instance;', ''}),
    t({'}', ''})
  }),

  -- https://github.com/LucasProcopio/moodle-main-functions-snippets 에서 병합.

  -- Moodle Form add header element
  s('mdl_form_header', {
    t("$mform->addElement("), i(1, "'header'"), t(", "), i(2, "'name'"), t(", "), i(3, "get_string('string', 'pluginname')"), t(");"),
  }),

  -- Moodle Form add a element
  s('mdl_form_ele', {
    t("$mform->addElement("), i(1, "'element'"), t(", "), i(2, "'name'"), t(", "), i(3, "get_string('string', 'pluginname')"), t(");"),
  }),

  -- Moodle Form add action buttons
  s('mdl_form_btn', {
    t("$this->add_action_buttons("), i(1, "false"), t(", "), i(2, "get_string('string', 'pluginname')"), t(");"),
  }),

  -- Moodle Form add a complete set of elements (type, rule, help button)
  s('mdl_form', {
    t("$mform->addElement("), i(1, "'element'"), t(", "), i(2, "'name'"), t(", "), i(3, "get_string('string', 'pluginname')"), t({");", ''}),
    t("$mform->setType("), i(4, "'name'"), t(", "), i(5, "PARAM_TYPE"), t({");", ''}),
    t("$mform->addRule("), i(6, "'name'"), t(", "), i(7, "get_string('string', 'pluginname')"), t(", "), i(8, "'required'"), t(", "), i(9, "null"), t(", "), i(10, "'server'"), t({");", ''}),
    t("$mform->addHelpButton("), i(11, "'name'"), t(", "), i(12, "'name'"), t(", "), i(13, "'pluginname'"), t(");"),
  }),

  -- Moodle Form add multi select
  s('mdl_form_multise', {
    t("$select = $mform->addElement("), i(1, "'select'"), t(", "), i(2, "'name'"), t(", "), i(3, "get_string('string', 'pluginname')"), t(", "), i(4, "$options = []"), t(", "), i(5, "$attributes"), t({");", ''}),
    t("$select->setMultiple(true);"),
  }),

  -- Moodle error notification
  s('mdl_err_n', {
    t("\\core\\notification::error("), i(1, "get_string('string', 'pluginname')"), t(");"),
  }),

  -- Moodle warning notification
  s('mdl_warn_n', {
    t("\\core\\notification::warning("), i(1, "get_string('string', 'pluginname')"), t(");"),
  }),

  -- Moodle info notification
  s('mdl_inf_n', {
    t("\\core\\notification::info("), i(1, "get_string('string', 'pluginname')"), t(");"),
  }),

  -- Moodle success notification
  s('mdl_suc_n', {
    t("\\core\\notification::success("), i(1, "get_string('string', 'pluginname')"), t(");"),
  }),

  -- Moodle problem notification
  s('mdl_prob_n', {
    t("\\core\\notification::problem("), i(1, "get_string('string', 'pluginname')"), t(");"),
  }),

  -- Moodle custom type notification
  s('mdl_add_n', {
    t("\\core\\notification::add("), i(1, "get_string('string', 'pluginname')"), t(", "), i(2, "'type'"), t(");"),
  }),

  -- Moodle redirect with success notification
  s('mdl_redir_sucn', {
    t("redirect('/index.php', get_string('string', 'pluginname'), null, \\core\\output\\notification::NOTIFY_SUCCESS);"),
  }),

  -- Moodle redirect with error notification
  s('mdl_redir_errn', {
    t("redirect('/index.php', get_string('string', 'pluginname'), null, \\core\\output\\notification::NOTIFY_ERROR);"),
  }),

  -- Moodle basic page skeleton
  s('mdl_page', {
    t({"require_once(__DIR__.'/../../config.php');", ''}),
    t("$plugin_name = "), i(1, "'type_pluginname'"), t({';', ''}),
    t({'require_login();', ''}),
    t("$PAGE->set_url($CFG->wwwroot.'"), i(2, '/path/pagefile.php'), t({"');", ''}),
    t({'$context = context_system::instance();', ''}),
    t({'$PAGE->set_context($context);', ''}),
    t("$PAGE->set_title(get_string('"), i(3, 'string'), t({"', $plugin_name));", ''}),
    t("$PAGE->set_heading(get_string('"), i(4, 'string'), t({"', $plugin_name));", ''}),
    t({"$PAGE->set_pagelayout('admin');", '', 'echo $OUTPUT->header();', '', ''}),
    i(5, '// your code here ...'),
    t({'', '', 'echo $OUTPUT->footer();'}),
  }),

  -- Moodle table_sql skeleton
  s('mdl_table_sql', {
    t({'/**', '* Table class documentation', '*/', 'class '}),
    i(1, 'pluginname'),
    t({'_table extends table_sql {', '', '\t/**',
      '\t* Constructor',
      '\t*@param int $uniqueid all tables have to have a unique id',
      '\t*/',
      '\tfunction __construct($uniqueid) {',
      '\t\tparent::__construct($uniqueid);',
      '\t\t// Define the list of columns to show.',
      "\t\t$columns = array('username', 'password', 'firstname', 'lastname');",
      '\t\t$this->define_columns($columns);',
      '',
      '\t\t// Define the titles of columns to show in header.',
      "\t\t$headers = array('Username', 'Password', 'First name', 'Last name');",
      '\t\t$this->define_headers($headers);',
      '\t}',
      '',
      '\t/**',
      '\t*This function is called for each data row to allow processing of the username value.',
      '\t* @param object $values Contains object with all the values of record.',
      '\t* @return $string personalized string value for username column',
      '\t*/',
      '\tfunction col_username($values) {',
      "\t\t// If the data is being downloaded than we don't want to show HTML.",
      '\t\tif ($this->is_downloading()) {',
      '\t\t\treturn $values->username;',
      '\t\t} else {',
      '\t\t\t return \'<a href="/user/profile.php?id=\'.$values->id.\'">\'.$values->username.\'</a>\';',
      '\t\t}',
      '\t}',
      '',
      '\t/**',
      '\t*This function is called for each data row to allow processing of columns which do not have a *_cols function.',
      '\t* @return string return processed value. Return NULL if no change has been made',
      '\t*/',
      '\tfunction other_cols($colname, $value) {',
      "\t\t// For security reasons we don't want to show the password hash.",
      "\t\tif ($colname == 'password') {",
      '\t\t\treturn "****";',
      '\t\t}',
      '\t}',
      '}',
    }),
  }),

  -- Moodle version.php skeleton
  s('mdl_version_skeleton', {
    t({'/**', '* Plugin file documentation', '* @author '}),
    i(1, 'YOUR NAME'),
    t({'', '* @package '}),
    i(2, 'type_pluginname'),
    t({'', '*/', ''}),
    t({"defined('MOODLE_INTERNAL') || die();", '', ''}),
    t("$plugin->component = '"), i(3, 'type_pluginname'), t({"';", ''}),
    t("$plugin->version = "), i(4, 'YYYYMMDDXX'), t({';', ''}),
    t("$plugin->release = '"), i(5, 'v1.0.0'), t("';"),
  }),

  -- https://github.com/ManuelGil/vscode-moodle-snippets 에서 병합.

  -- A very few webhosts use /admin as a special URL for you to access a control panel or something. Unfortunately this conflicts with the standard location for the Moodle admin pages. You can work around this by renaming the admin directory in your installation, and putting that new name here.
  s('mdl_cfg_admin', {
    t("$CFG->admin"),
  }),

  -- Cache location
  s('mdl_cfg_cachedir', {
    t("$CFG->cachedir"),
  }),

  -- The place where Moodle can save uploaded files. This directory should be readable and writeable by the web server user but it should not be accessible directly via the web
  s('mdl_cfg_dataroot', {
    t("$CFG->dataroot"),
  }),

  -- The dirroot is the name for the directory in which you have installed Moodle. It's a setting in config.php that must be entered correctly
  s('mdl_cfg_dirroot', {
    t("$CFG->dirroot"),
  }),

  -- Path to documentation like: http://docs.moodle.org.
  s('mdl_cfg_docroot', {
    t("$CFG->docroot"),
  }),

  -- Specifies the full web address with http\https to where moodle has been installed. If your web site is accessible via multiple URLs then it is the most natural one that your students would use. Do not contain a trailing slash
  s('mdl_cfg_httpswwwroot', {
    t("$CFG->httpswwwroot"),
  }),

  -- Configurated lang
  s('mdl_cfg_lang', {
    t("$CFG->lang"),
  }),

  -- Path to /lib directory
  s('mdl_cfg_libdir', {
    t("$CFG->libdir"),
  }),

  -- Local cache directory path
  s('mdl_cfg_localcachedir', {
    t("$CFG->localcachedir"),
  }),

  -- Path to temporary directory
  s('mdl_cfg_tempdir', {
    t("$CFG->tempdir"),
  }),

  -- Specifies the full web address to where moodle has been installed. If your web site is accessible via multiple URLs then it is the most natural one that your students would use. Do not contain a trailing slash
  s('mdl_cfg_wwwroot', {
    t("$CFG->wwwroot"),
  }),

  -- Loads and returns a database instance with the specified type and library. The loaded class is within lib/dml directory and of the form: $type.'_'.$library.'_moodle_database'.
  s('mdl_db_get_driver_instance', {
    t("$DB::get_driver_instance("),
    i(1, "$type"),
    t(", "),
    i(2, "$library"),
    i(3, ", $external"),
    t(");"),
  }),

  -- Detects if all needed PHP stuff are installed for DB connectivity. Can be used before connect()
  s('mdl_db_driver_installed', {
    t("$DB->driver_installed();"),
  }),

  -- Returns database table prefix can be used before connect().
  s('mdl_db_get_prefix', {
    t("$DB->get_prefix();"),
  }),

  -- Returns the database vendor. Can be used before connect().
  s('mdl_db_get_dbvendor', {
    t("$DB->get_dbvendor();"),
  }),

  -- Returns the database family type. (This sort of describes the SQL 'dialect') can be used before connect().
  s('mdl_db_get_dbfamily', {
    t("$DB->get_dbfamily();"),
  }),

  -- Returns the localised database type name can be used before connect().
  s('mdl_db_get_name', {
    t("$DB->get_name();"),
  }),

  -- Returns the localised database configuration help. Can be used before connect().
  s('mdl_db_get_configuration_help', {
    t("$DB->get_configuration_help();"),
  }),

  -- DEPRECATED SINCE 2.6. Returns the localised database description can be used before connect().
  s('mdl_db_get_configuration_hints', {
    t("$DB->get_configuration_hints();"),
  }),

  -- Returns the db related part of config.php
  s('mdl_db_export_dbconfig', {
    t("$DB->export_dbconfig();"),
  }),

  -- Diagnose database and tables, this function is used to verify database and driver settings, db engine types, etc.
  s('mdl_db_diagnose', {
    t("$DB->diagnose();"),
  }),

  -- Connects to the database. Must be called before other methods.
  s('mdl_db_connect', {
    t("$DB->connect("),
    i(1, "$dbhost"),
    t(", "),
    i(2, "$dbuser"),
    t(", "),
    i(3, "$dbpass"),
    t(", "),
    i(4, "$dbname"),
    t(", "),
    i(5, "$prefix"),
    i(6, ", $dboptions_array"),
    t(");"),
  }),

  -- Attempt to create the database.
  s('mdl_db_create_database', {
    t("$DB->create_database("),
    i(1, "$dbhost"),
    t(", "),
    i(2, "$dbuser"),
    t(", "),
    i(3, "$dbpass"),
    t(", "),
    i(4, "$dbname"),
    i(5, ", $dboptions_array"),
    t(");"),
  }),

  -- Returns transaction trace for debugging purposes. @private to be used by core only
  s('mdl_db_get_transaction_start_backtrace', {
    t("$DB->get_transaction_start_backtrace();"),
  }),

  -- Closes the database connection and releases all resources and memory (especially circular memory references). Do NOT use connect() again, create a new instance if needed.
  s('mdl_db_dispose', {
    t("$DB->dispose();"),
  }),

  -- This logs the last query based on 'logall', 'logslow' and 'logerrors' options configured via $CFG->dboptions .
  s('mdl_db_query_log', {
    t("$DB->query_log("),
    i(1, "$error"),
    t(");"),
  }),

  -- Returns database server info array
  s('mdl_db_get_server_info', {
    t("$DB->get_server_info();"),
  }),

  -- Returns the last error reported by the database engine.
  s('mdl_db_get_last_error', {
    t("$DB->get_last_error();"),
  }),

  -- Constructs 'IN()' or '=' sql fragment
  s('mdl_db_get_in_or_equal', {
    t("$DB->get_in_or_equal("),
    i(1, "$items"),
    i(2, ", ${3|SQL_PARAMS_QM,SQL_PARAMS_NAMED|}, $prefix, $equal, $onemptyitems"),
    t(");"),
  }),

  -- Normalizes sql query parameters and verifies parameters.
  s('mdl_db_fix_sql_params', {
    t("$DB->fix_sql_params("),
    i(1, "$sql"),
    i(2, ", $params_array"),
    t(");"),
  }),

  -- Return tables in database WITHOUT current prefix.
  s('mdl_db_get_tables', {
    t("$DB->get_tables("),
    i(1, "$usecache"),
    t(");"),
  }),

  -- Return table indexes - everything lowercased.
  s('mdl_db_get_indexes', {
    t("$DB->get_indexes("),
    i(1, "$table"),
    t(");"),
  }),

  -- Returns detailed information about columns in table. This information is cached internally.
  s('mdl_db_get_columns', {
    t("$DB->get_columns("),
    i(1, "$table"),
    i(2, ", $usecache"),
    t(");"),
  }),

  -- Resets the internal column details cache
  s('mdl_db_reset_caches', {
    t("$DB->reset_caches("),
    i(1, "$tablenames"),
    t(");"),
  }),

  -- Returns the sql generator used for db manipulation. Used mostly in upgrade.php scripts.
  s('mdl_db_get_manager', {
    t("$DB->get_manager();"),
  }),

  -- Attempts to change db encoding to UTF-8 encoding if possible.
  s('mdl_db_change_db_encoding', {
    t("$DB->change_db_encoding();"),
  }),

  -- Checks to see if the database is in unicode mode?
  s('mdl_db_setup_is_unicodedb', {
    t("$DB->setup_is_unicodedb();"),
  }),

  -- Enable/disable very detailed debugging.
  s('mdl_db_set_debug', {
    t("$DB->set_debug("),
    i(1, "$state"),
    t(");"),
  }),

  -- Returns debug status
  s('mdl_db_get_debug', {
    t("$DB->get_debug();"),
  }),

  -- DEPRECATED SINCE MOODLE 2.9. Enable/disable detailed sql logging
  s('mdl_db_set_logging', {
    t("$DB->set_logging("),
    i(1, "$state"),
    t(");"),
  }),

  -- Do NOT use in code, this is for use by database_manager only!
  s('mdl_db_change_database_structure', {
    t("$DB->change_database_structure("),
    i(1, "$sql"),
    i(2, ", $tablenames"),
    t(");"),
  }),

  -- Executes a general sql query. Should be used only when no other method suitable. Do NOT use this to make changes in db structure, use database_manager methods instead!
  s('mdl_db_execute', {
    t("$DB->execute("),
    i(1, "$sql"),
    i(2, ", $params_array"),
    t(");"),
  }),

  -- Get a number of records as a moodle_recordset where all the given conditions met.
  s('mdl_db_get_recordset', {
    t("$DB->get_recordset("),
    i(1, "$table"),
    i(2, ", $conditions_array, $sort, $fields, $limitfrom, $limitnum"),
    t(");"),
  }),

  -- Get a number of records as a moodle_recordset where one field match one list of values.
  s('mdl_db_get_recordset_list', {
    t("$DB->get_recordset_list("),
    i(1, "$table"),
    t(", "),
    i(2, "$field"),
    t(", "),
    i(3, "$values_array"),
    i(4, ", $sort, $fields, $limitfrom, $limitnum"),
    t(");"),
  }),

  -- Get a number of records as a moodle_recordset which match a particular WHERE clause.
  s('mdl_db_get_recordset_select', {
    t("$DB->get_recordset_select("),
    i(1, "$table"),
    t(", "),
    i(2, "$select"),
    i(3, ", $params_array, $sort, $fields, $limitfrom, $limitnum"),
    t(");"),
  }),

  -- Get a number of records as a moodle_recordset using a SQL statement.
  s('mdl_db_get_recordset_sql', {
    t("$DB->get_recordset_sql("),
    i(1, "$sql"),
    i(2, ", $params_array, $limitfrom, $limitnum"),
    t(");"),
  }),

  -- Get all records from a table.
  s('mdl_db_export_table_recordset', {
    t("$DB->export_table_recordset("),
    i(1, "$table"),
    t(");"),
  }),

  -- Get a number of records as an array of objects where all the given conditions met.
  s('mdl_db_get_records', {
    t("$DB->get_records("),
    i(1, "$table"),
    i(2, ", $conditions_array, $sort, $fields, $limitfrom, $limitnum"),
    t(");"),
  }),

  -- Get a number of records as an array of objects where one field match one list of values.
  s('mdl_db_get_records_list', {
    t("$DB->get_records_list("),
    i(1, "$table"),
    t(", "),
    i(2, "$field"),
    t(", "),
    i(3, "$values_array"),
    i(4, ", $sort, $fields, $limitfrom, $limitnum"),
    t(");"),
  }),

  -- Get a number of records as an array of objects which match a particular WHERE clause.
  s('mdl_db_get_records_select', {
    t("$DB->get_records_select("),
    i(1, "$table"),
    t(", "),
    i(2, "$select"),
    i(3, ", $params_array, $sort, $fields, $limitfrom, $limitnum"),
    t(");"),
  }),

  -- Get a number of records as an array of objects using a SQL statement.
  s('mdl_db_get_records_sql', {
    t("$DB->get_records_sql("),
    i(1, "$sql"),
    i(2, ", $params_array, $limitfrom, $limitnum"),
    t(");"),
  }),

  -- Get the first two columns from a number of records as an associative array where all the given conditions met.
  s('mdl_db_get_records_menu', {
    t("$DB->get_records_menu("),
    i(1, "$table"),
    i(2, ", $conditions_array, $sort, $fields, $limitfrom, $limitnum"),
    t(");"),
  }),

  -- Get the first two columns from a number of records as an associative array which match a particular WHERE clause.
  s('mdl_db_get_records_select_menu', {
    t("$DB->get_records_select_menu("),
    i(1, "$table"),
    t(", "),
    i(2, "$select"),
    i(3, ", $params_array, $sort, $fields, $limitfrom, $limitnum"),
    t(");"),
  }),

  -- Get the first two columns from a number of records as an associative array using a SQL statement.
  s('mdl_db_get_records_sql_menu', {
    t("$DB->get_records_sql_menu("),
    i(1, "$sql"),
    i(2, ", $params_array, $limitfrom, $limitnum"),
    t(");"),
  }),

  -- Get a single database record as an object where all the given conditions met.
  s('mdl_db_get_record', {
    t("$DB->get_record("),
    i(1, "$table"),
    t(", "),
    i(2, "$conditions_array"),
    i(3, ", $fields, ${6|IGNORE_MISSING,IGNORE_MULTIPLE,MUST_EXIST|}"),
    t(");"),
  }),

  -- Get a single database record as an object which match a particular WHERE clause.
  s('mdl_db_get_record_select', {
    t("$DB->get_record_select("),
    i(1, "$table"),
    t(", "),
    i(2, "$select"),
    i(3, ", $params_array, $fields, ${8|IGNORE_MISSING,IGNORE_MULTIPLE,MUST_EXIST|}"),
    t(");"),
  }),

  -- Get a single database record as an object using a SQL statement.
  s('mdl_db_get_record_sql', {
    t("$DB->get_record_sql("),
    i(1, "$sql"),
    i(2, ", $params_array, ${5|IGNORE_MISSING,IGNORE_MULTIPLE,MUST_EXIST|}"),
    t(");"),
  }),

  -- Get a single field value from a table record where all the given conditions met.
  s('mdl_db_get_field', {
    t("$DB->get_field("),
    i(1, "$table"),
    t(", "),
    i(2, "$return"),
    t(", "),
    i(3, "$conditions_array"),
    i(4, ", ${5|IGNORE_MISSING,IGNORE_MULTIPLE,MUST_EXIST|}"),
    t(");"),
  }),

  -- Get a single field value from a table record which match a particular WHERE clause.
  s('mdl_db_get_field_select', {
    t("$DB->get_field_select("),
    i(1, "$table"),
    t(", "),
    i(2, "$return"),
    t(", "),
    i(3, "$select"),
    i(4, ", $params_array, ${7|IGNORE_MISSING,IGNORE_MULTIPLE,MUST_EXIST|}"),
    t(");"),
  }),

  -- Get a single field value (first field) using a SQL statement.
  s('mdl_db_get_field_sql', {
    t("$DB->get_field_sql("),
    i(1, "$sql"),
    i(2, ", $params_array, ${5|IGNORE_MISSING,IGNORE_MULTIPLE,MUST_EXIST|}"),
    t(");"),
  }),

  -- Selects records and return values of chosen field as an array which match a particular WHERE clause.
  s('mdl_db_get_fieldset_select', {
    t("$DB->get_fieldset_select("),
    i(1, "$table"),
    t(", "),
    i(2, "$return"),
    t(", "),
    i(3, "$select"),
    i(4, ", $params_array"),
    t(");"),
  }),

  -- Selects records and return values (first field) as an array using a SQL statement.
  s('mdl_db_get_fieldset_sql', {
    t("$DB->get_fieldset_sql("),
    i(1, "$sql"),
    i(2, ", $params_array"),
    t(");"),
  }),

  -- Insert new record into database, as fast as possible, no safety checks, lobs not supported.
  s('mdl_db_insert_record_raw', {
    t("$DB->insert_record_raw("),
    i(1, "$table"),
    t(", "),
    i(2, "$params"),
    i(3, ", $returnid, $bulk, $customsequence"),
    t(");"),
  }),

  -- Insert a record into a table and return the "id" field if required.
  s('mdl_db_insert_record', {
    t("$DB->insert_record("),
    i(1, "$table"),
    t(", "),
    i(2, "$dataobject"),
    i(3, ", $returnid, $bulk"),
    t(");"),
  }),

  -- Insert multiple records into database as fast as possible.
  s('mdl_db_insert_records', {
    t("$DB->insert_records("),
    i(1, "$table"),
    t(", "),
    i(2, "$dataobjects"),
    t(");"),
  }),

  -- Import a record into a table, id field is required. Safety checks are NOT carried out. Lobs are supported.
  s('mdl_db_import_record', {
    t("$DB->import_record("),
    i(1, "$table"),
    t(", "),
    i(2, "$dataobject"),
    t(");"),
  }),

  -- Update record in database, as fast as possible, no safety checks, lobs not supported.
  s('mdl_db_update_record_raw', {
    t("$DB->update_record_raw("),
    i(1, "$table"),
    t(", "),
    i(2, "$params"),
    i(3, ", $bulk"),
    t(");"),
  }),

  -- Update a record in a table
  s('mdl_db_update_record', {
    t("$DB->update_record("),
    i(1, "$table"),
    t(", "),
    i(2, "$dataobject"),
    i(3, ", $bulk"),
    t(");"),
  }),

  -- Set a single field in every table record where all the given conditions met.
  s('mdl_db_set_field', {
    t("$DB->set_field("),
    i(1, "$table"),
    t(", "),
    i(2, "$newfield"),
    t(", "),
    i(3, "$newvalue"),
    i(4, ", $conditions_array"),
    t(");"),
  }),

  -- Set a single field in every table record which match a particular WHERE clause.
  s('mdl_db_set_field_select', {
    t("$DB->set_field_select("),
    i(1, "$table"),
    t(", "),
    i(2, "$newfield"),
    t(", "),
    i(3, "$newvalue"),
    t(", "),
    i(4, "$select"),
    i(5, ", $params_array"),
    t(");"),
  }),

  -- Count the records in a table where all the given conditions met.
  s('mdl_db_count_records', {
    t("$DB->count_records("),
    i(1, "$table"),
    i(2, ", $conditions_array"),
    t(");"),
  }),

  -- Count the records in a table which match a particular WHERE clause.
  s('mdl_db_count_records_select', {
    t("$DB->count_records_select("),
    i(1, "$table"),
    t(", "),
    i(2, "$select"),
    i(3, ", $params_array, $countitem"),
    t(");"),
  }),

  -- Get the result of a SQL SELECT COUNT(...) query.
  s('mdl_db_count_records_sql', {
    t("$DB->count_records_sql("),
    i(1, "$sql"),
    i(2, ", $params_array"),
    t(");"),
  }),

  -- Test whether a record exists in a table where all the given conditions met.
  s('mdl_db_record_exists', {
    t("$DB->record_exists("),
    i(1, "$table"),
    t(", "),
    i(2, "$conditions_array"),
    t(");"),
  }),

  -- Test whether any records exists in a table which match a particular WHERE clause.
  s('mdl_db_record_exists_select', {
    t("$DB->record_exists_select("),
    i(1, "$table"),
    t(", "),
    i(2, "$select"),
    i(3, ", $params_array"),
    t(");"),
  }),

  -- Test whether a SQL SELECT statement returns any records.
  s('mdl_db_record_exists_sql', {
    t("$DB->record_exists_sql("),
    i(1, "$sql"),
    i(2, ", $params_array"),
    t(");"),
  }),

  -- Delete the records from a table where all the given conditions met. If conditions not specified, table is truncated.
  s('mdl_db_delete_records', {
    t("$DB->delete_records("),
    i(1, "$table"),
    i(2, ", $conditions_array"),
    t(");"),
  }),

  -- Delete the records from a table where one field match one list of values.
  s('mdl_db_delete_records_list', {
    t("$DB->delete_records_list("),
    i(1, "$table"),
    t(", "),
    i(2, "$field"),
    t(", "),
    i(3, "$values_array"),
    t(");"),
  }),

  -- Delete one or more records from a table which match a particular WHERE clause.
  s('mdl_db_delete_records_select', {
    t("$DB->delete_records_select("),
    i(1, "$table"),
    t(", "),
    i(2, "$select"),
    i(3, ", $params_array"),
    t(");"),
  }),

  -- Returns the FROM clause required by some DBs in all SELECT statements.
  s('mdl_db_sql_null_from_clause', {
    t("$DB->sql_null_from_clause();"),
  }),

  -- Returns the SQL text to be used in order to perform one bitwise AND operation between 2 integers.
  s('mdl_db_sql_bitand', {
    t("$DB->sql_bitand("),
    i(1, "$int1"),
    t(", "),
    i(2, "$int2"),
    t(");"),
  }),

  -- Returns the SQL text to be used in order to perform one bitwise NOT operation with 1 integer.
  s('mdl_db_sql_bitnot', {
    t("$DB->sql_bitnot("),
    i(1, "$int1"),
    t(");"),
  }),

  -- Returns the SQL text to be used in order to perform one bitwise OR operation between 2 integers.
  s('mdl_db_sql_bitor', {
    t("$DB->sql_bitor("),
    i(1, "$int1"),
    t(", "),
    i(2, "$int2"),
    t(");"),
  }),

  -- Returns the SQL text to be used in order to perform one bitwise XOR operation between 2 integers.
  s('mdl_db_sql_bitxor', {
    t("$DB->sql_bitxor("),
    i(1, "$int1"),
    t(", "),
    i(2, "$int2"),
    t(");"),
  }),

  -- Returns the SQL text to be used in order to perform module '%' operation - remainder after division.
  s('mdl_db_sql_modulo', {
    t("$DB->sql_modulo("),
    i(1, "$int1"),
    t(", "),
    i(2, "$int2"),
    t(");"),
  }),

  -- Returns the cross db correct CEIL (ceiling) expression applied to fieldname. Most DBs use CEIL(), hence it's the default here.
  s('mdl_db_sql_ceil', {
    t("$DB->sql_ceil("),
    i(1, "$fieldname"),
    t(");"),
  }),

  -- Returns the SQL to be used in order to CAST one CHAR column to INTEGER.
  s('mdl_db_sql_cast_char2int', {
    t("$DB->sql_cast_char2int("),
    i(1, "$fieldname"),
    i(2, ", $text"),
    t(");"),
  }),

  -- Returns the SQL to be used in order to CAST one CHAR column to REAL number.
  s('mdl_db_sql_cast_char2real', {
    t("$DB->sql_cast_char2real("),
    i(1, "$fieldname"),
    i(2, ", $text"),
    t(");"),
  }),

  -- DEPRECATED SINCE 2.3. Returns the SQL to be used in order to an UNSIGNED INTEGER column to SIGNED.
  s('mdl_db_sql_cast_2signed', {
    t("$DB->sql_cast_2signed("),
    i(1, "$fieldname"),
    t(");"),
  }),

  -- Returns the SQL text to be used to compare one TEXT (clob) column with one varchar column, because some RDBMS doesn't support such direct comparisons.
  s('mdl_db_sql_compare_text', {
    t("$DB->sql_compare_text("),
    i(1, "$fieldname"),
    i(2, ", $numchars"),
    t(");"),
  }),

  -- Returns an equal (=) or not equal (<>) part of a query.
  s('mdl_db_sql_equal', {
    t("$DB->sql_equal("),
    i(1, "$fieldname"),
    t(", "),
    i(2, "$param"),
    i(3, ", $casesensitive, $accentsensitive, $notequal"),
    t(");"),
  }),

  -- Returns 'LIKE' part of a query.
  s('mdl_db_sql_like', {
    t("$DB->sql_like("),
    i(1, "$fieldname"),
    t(", "),
    i(2, "$param"),
    i(3, ", $casesensitive, $accentsensitive, $notlike, $escapechar"),
    t(");"),
  }),

  -- Escape sql LIKE special characters like '_' or '%'.
  s('mdl_db_sql_like_escape', {
    t("$DB->sql_like_escape("),
    i(1, "$text"),
    i(2, ", $escapechar"),
    t(");"),
  }),

  -- Returns the proper SQL to do CONCAT between the elements(fieldnames) passed.
  s('mdl_db_sql_concat', {
    t("$DB->sql_concat();"),
  }),

  -- Returns the proper SQL to do CONCAT between the elements passed with a given separator
  s('mdl_db_sql_concat_join', {
    t("$DB->sql_concat_join("),
    i(1, "$separator, $elements"),
    t(");"),
  }),

  -- Returns the proper SQL (for the dbms in use) to concatenate $firstname and $lastname
  s('mdl_db_sql_fullname', {
    t("$DB->sql_fullname("),
    i(1, "$first, $last"),
    t(");"),
  }),

  -- Returns the SQL text to be used to order by one TEXT (clob) column, because some RDBMS doesn't support direct ordering of such fields.
  s('mdl_db_sql_order_by_text', {
    t("$DB->sql_order_by_text("),
    i(1, "$fieldname"),
    i(2, ", $numchars"),
    t(");"),
  }),

  -- Returns the SQL text to be used to calculate the length in characters of one expression.
  s('mdl_db_sql_length', {
    t("$DB->sql_length("),
    i(1, "$fieldname"),
    t(");"),
  }),

  -- Returns the proper substr() SQL text used to extract substrings from DB this was originally returning only function name
  s('mdl_db_sql_substr', {
    t("$DB->sql_substr("),
    i(1, "$expr"),
    t(", "),
    i(2, "$start"),
    i(3, ", $length"),
    t(");"),
  }),

  -- Returns the SQL for returning searching one string for the location of another.
  s('mdl_db_sql_position', {
    t("$DB->sql_position("),
    i(1, "$needle"),
    t(", "),
    i(2, "$haystack"),
    t(");"),
  }),

  -- DEPRECATED USE BOUND PARAMETER WITH EMPTY STRING INSTEAD. This used to return empty string replacement character.
  s('mdl_db_sql_empty', {
    t("$DB->sql_empty();"),
  }),

  -- Returns the proper SQL to know if one field is empty.
  s('mdl_db_sql_isempty', {
    t("$DB->sql_isempty("),
    i(1, "$tablename"),
    t(", "),
    i(2, "$fieldname"),
    t(", "),
    i(3, "$nullablefield"),
    t(", "),
    i(4, "$textfield"),
    t(");"),
  }),

  -- Returns the proper SQL to know if one field is not empty.
  s('mdl_db_sql_isnotempty', {
    t("$DB->sql_isnotempty("),
    i(1, "$tablename"),
    t(", "),
    i(2, "$fieldname"),
    t(", "),
    i(3, "$nullablefield"),
    t(", "),
    i(4, "$textfield"),
    t(");"),
  }),

  -- Returns true if this database driver supports regex syntax when searching.
  s('mdl_db_sql_regex_supported', {
    t("$DB->sql_regex_supported();"),
  }),

  -- Returns the driver specific syntax (SQL part) for matching regex positively or negatively (inverted matching). Eg: 'REGEXP':'NOT REGEXP' or '~*' : '!~*'
  s('mdl_db_sql_regex', {
    t("$DB->sql_regex("),
    i(1, "$positivematch, $casesensitive"),
    t(");"),
  }),

  -- Returns the SQL that allows to find intersection of two or more queries
  s('mdl_db_sql_intersect', {
    t("$DB->sql_intersect("),
    i(1, "$selects"),
    t(", "),
    i(2, "$fields"),
    t(");"),
  }),

  -- Does this driver support tool_replace?
  s('mdl_db_replace_all_text_supported', {
    t("$DB->replace_all_text_supported();"),
  }),

  -- Replace given text in all rows of column.
  s('mdl_db_replace_all_text', {
    t("$DB->replace_all_text("),
    i(1, "$table"),
    t(", "),
    i(2, "$database_column_info"),
    t(", "),
    i(3, "$search"),
    t(", "),
    i(4, "$replace"),
    t(");"),
  }),

  -- Analyze the data in temporary tables to force statistics collection after bulk data loads.
  s('mdl_db_update_temp_table_stats', {
    t("$DB->update_temp_table_stats();"),
  }),

  -- Returns true if a transaction is in progress.
  s('mdl_db_is_transaction_started', {
    t("$DB->is_transaction_started();"),
  }),

  -- This is a test that throws an exception if transaction in progress. This test does not force rollback of active transactions.
  s('mdl_db_transactions_forbidden', {
    t("$DB->transactions_forbidden();"),
  }),

  -- On DBs that support it, switch to transaction mode and begin a transaction you'll need to ensure you call allow_commit() on the returned object or your changes *will* be lost.
  s('mdl_db_start_delegated_transaction', {
    t("$DB->start_delegated_transaction();"),
  }),

  -- Indicates delegated transaction finished successfully. The real database transaction is committed only if all delegated transactions committed.
  s('mdl_db_commit_delegated_transaction', {
    t("$DB->commit_delegated_transaction("),
    i(1, "$moodle_transaction"),
    t(");"),
  }),

  -- Call when delegated transaction failed, this rolls back all delegated transactions up to the top most level.
  s('mdl_db_rollback_delegated_transaction', {
    t("$DB->rollback_delegated_transaction("),
    i(1, "$moodle_transaction"),
    t(", "),
    i(2, "$exception"),
    t(");"),
  }),

  -- Force rollback of all delegated transaction. Does not throw any exceptions and does not log anything.
  s('mdl_db_force_transaction_rollback', {
    t("$DB->force_transaction_rollback();"),
  }),

  -- Is session lock supported in this driver?
  s('mdl_db_session_lock_supported', {
    t("$DB->session_lock_supported();"),
  }),

  -- Obtains the session lock.
  s('mdl_db_get_session_lock', {
    t("$DB->get_session_lock("),
    i(1, "$rowid"),
    t(", "),
    i(2, "$timeout"),
    t(");"),
  }),

  -- Releases the session lock.
  s('mdl_db_release_session_lock', {
    t("$DB->release_session_lock("),
    i(1, "$rowid"),
    t(");"),
  }),

  -- Returns the number of reads done by this database.
  s('mdl_db_perf_get_reads', {
    t("$DB->perf_get_reads();"),
  }),

  -- Returns the number of writes done by this database.
  s('mdl_db_perf_get_writes', {
    t("$DB->perf_get_writes();"),
  }),

  -- Returns the number of queries done by this database.
  s('mdl_db_perf_get_queries', {
    t("$DB->perf_get_queries();"),
  }),

  -- Time waiting for the database engine to finish running all queries.
  s('mdl_db_perf_get_queries_time', {
    t("$DB->perf_get_queries_time();"),
  }),

  -- Renders an action_icon.
  s('mdl_output_action_icon', {
    t("$OUTPUT->action_icon("),
    i(1, "$url"),
    t(", "),
    i(2, "$pix_icon"),
    i(3, ", $component_action, $attributes_array, $linktext"),
    t(");"),
  }),

  -- Renders a special html link with attached action.
  s('mdl_output_action_link', {
    t("$OUTPUT->action_link("),
    i(1, "$url"),
    t(", "),
    i(2, "$text"),
    i(3, ", $component_action, $attributes_array, $icon"),
    t(");"),
  }),

  -- Returns standard navigation between activities in a course.
  s('mdl_output_activity_navigation', {
    t("$OUTPUT->activity_navigation();"),
  }),

  -- Adds a JS action for the element with the provided id.
  s('mdl_output_add_action_handler', {
    t("$OUTPUT->add_action_handler("),
    i(1, "$component_action"),
    i(2, ", $id"),
    t(");"),
  }),

  -- Prints a nice side block with an optional header.
  s('mdl_output_block', {
    t("$OUTPUT->block("),
    i(1, "$block_contents"),
    t(", "),
    i(2, "$region"),
    t(");"),
  }),

  -- Output the row of editing icons for a block, as defined by the controls array.
  s('mdl_output_block_controls', {
    t("$OUTPUT->block_controls("),
    i(1, "$actions"),
    i(2, ", $blockid"),
    t(");"),
  }),

  -- Output a place where the block that is currently being moved can be dropped.
  s('mdl_output_block_move_target', {
    t("$OUTPUT->block_move_target("),
    i(1, "$target"),
    t(", "),
    i(2, "$zones"),
    t(", "),
    i(3, "$previous"),
    t(", "),
    i(4, "$region"),
    t(");"),
  }),

  -- Get the HTML for blocks in the given region.
  s('mdl_output_blocks', {
    t("$OUTPUT->blocks("),
    i(1, "$region"),
    i(2, ", $classes, $tag"),
    t(");"),
  }),

  -- Does nothing. The maintenance renderer cannot produce blocks.
  s('mdl_output_blocks_for_region', {
    t("$OUTPUT->blocks_for_region("),
    i(1, "$region"),
    t(");"),
  }),

  -- Returns HTML attributes to use within the body tag. This includes an ID and classes.
  s('mdl_output_body_attributes', {
    t("$OUTPUT->body_attributes("),
    i(1, "$additionalclasses_array"),
    t(");"),
  }),

  -- Returns the CSS classes to apply to the body tag.
  s('mdl_output_body_css_classes', {
    t("$OUTPUT->body_css_classes("),
    i(1, "$additionalclasses_array"),
    t(");"),
  }),

  -- The ID attribute to apply to the body tag.
  s('mdl_output_body_id', {
    t("$OUTPUT->body_id();"),
  }),

  -- Outputs a box.
  s('mdl_output_box', {
    t("$OUTPUT->box("),
    i(1, "$contents"),
    i(2, ", $classes, $id, $attributes"),
    t(");"),
  }),

  -- Outputs the closing section of a box.
  s('mdl_output_box_end', {
    t("$OUTPUT->box_end();"),
  }),

  -- Outputs the opening section of a box.
  s('mdl_output_box_start', {
    t("$OUTPUT->box_start("),
    i(1, "$classes, $id, $attributes);"),
  }),

  -- Returns HTML to display a simple button to close a window.
  s('mdl_output_close_window_button', {
    t("$OUTPUT->close_window_button("),
    i(1, "$text"),
    t(");"),
  }),

  -- Print a message along with button choices for Continue/Cancel.
  s('mdl_output_confirm', {
    t("$OUTPUT->confirm("),
    i(1, "$message"),
    t(", "),
    i(2, "$continue"),
    t(", "),
    i(3, "$cancel"),
    t(");"),
  }),

  -- Outputs a container.
  s('mdl_output_container', {
    t("$OUTPUT->container("),
    i(1, "$contents"),
    i(2, ", $classes, $id"),
    t(");"),
  }),

  -- Outputs the closing section of a container.
  s('mdl_output_container_end', {
    t("$OUTPUT->container_end();"),
  }),

  -- Close all but the last open container.
  s('mdl_output_container_end_all', {
    t("$OUTPUT->container_end_all("),
    i(1, "$shouldbenone"),
    t(");"),
  }),

  -- Outputs the opening section of a container.
  s('mdl_output_container_start', {
    t("$OUTPUT->container_start("),
    i(1, "$classes, $id"),
    t(");"),
  }),

  -- Context header bar.
  s('mdl_output_context_header', {
    t("$OUTPUT->context_header("),
    i(1, "$headerinfo, $headinglevel"),
    t(");"),
  }),

  -- Returns HTML to display a continue button that goes to a particular URL.
  s('mdl_output_continue_button', {
    t("$OUTPUT->continue_button("),
    i(1, "$url"),
    t(");"),
  }),

  -- Does nothing. The maintenance renderer cannot produce a course content footer.
  s('mdl_output_course_content_footer', {
    t("$OUTPUT->course_content_footer("),
    i(1, "$onlyifnotcalledbefore"),
    t(");"),
  }),

  -- Does nothing. The maintenance renderer cannot produce a course content header.
  s('mdl_output_course_content_header', {
    t("$OUTPUT->course_content_header("),
    i(1, "$onlyifnotcalledbefore"),
    t(");"),
  }),

  -- Does nothing. The maintenance renderer cannot produce a course footer.
  s('mdl_output_course_footer', {
    t("$OUTPUT->course_footer();"),
  }),

  -- Does nothing. The maintenance renderer cannot produce a course header.
  s('mdl_output_course_header', {
    t("$OUTPUT->course_header();"),
  }),

  -- Renders a custom block region.
  s('mdl_output_custom_block_region', {
    t("$OUTPUT->custom_block_region("),
    i(1, "$regionname"),
    t(");"),
  }),

  -- Does nothing. The maintenance renderer cannot produce a custom menu.
  s('mdl_output_custom_menu', {
    t("$OUTPUT->custom_menu("),
    i(1, "$custommenuitems"),
    t(");"),
  }),

  -- Accessibility: Down arrow-like character.
  s('mdl_output_darrow', {
    t("$OUTPUT->darrow();"),
  }),

  -- Returns a string containing a link to the user documentation. Also contains an icon by default. Shown to teachers and admin only.
  s('mdl_output_doc_link', {
    t("$OUTPUT->doc_link("),
    i(1, "$path"),
    i(2, ", $text, $forcepopup"),
    t(");"),
  }),

  -- Get the DOCTYPE declaration that should be used with this page. Designed to be called in theme layout.php files.
  s('mdl_output_doctype', {
    t("$OUTPUT->doctype();"),
  }),

  -- Returns a dataformat selection and download form.
  s('mdl_output_download_dataformat_selector', {
    t("$OUTPUT->download_dataformat_selector("),
    i(1, "$label"),
    t(", "),
    i(2, "$base"),
    i(3, ", $name, $params"),
    t(");"),
  }),

  -- Returns HTML to display a "Turn editing on/off" button in a form.
  s('mdl_output_edit_button', {
    t("$OUTPUT->edit_button("),
    i(1, "$moodle_url"),
    t(");"),
  }),

  -- Output an error message. By default wraps the error message in <span class="error">. If the error message is blank, nothing is output.
  s('mdl_output_error_text', {
    t("$OUTPUT->error_text("),
    i(1, "$message"),
    t(");"),
  }),

  -- Do not call this function directly. To terminate the current script with a fatal error, call the {@link print_error} function, or throw an exception. Doing either of those things will then call this function to display the error, before terminating the execution.
  s('mdl_output_fatal_error', {
    t("$OUTPUT->fatal_error("),
    i(1, "$message"),
    t(", "),
    i(2, "$moreinfourl"),
    t(", "),
    i(3, "$link"),
    t(", "),
    i(4, "$backtrace"),
    i(5, ", $debuginfo, $errorcode"),
    t(");"),
  }),

  -- Returns the URL for the favicon.
  s('mdl_output_favicon', {
    t("$OUTPUT->favicon();"),
  }),

  -- Does nothing. The maintenance renderer cannot produce a file picker.
  s('mdl_output_file_picker', {
    t("$OUTPUT->file_picker("),
    i(1, "$options"),
    t(");"),
  }),

  -- Outputs the page's footer.
  s('mdl_output_footer', {
    t("$OUTPUT->footer();"),
  }),

  -- Wrapper for header elements.
  s('mdl_output_full_header', {
    t("$OUTPUT->full_header();"),
  }),

  -- Return the site's compact logo URL, if any.
  s('mdl_output_get_compact_logo_url', {
    t("$OUTPUT->get_compact_logo_url("),
    i(1, "$maxwidth, $maxheight"),
    t(");"),
  }),

  -- Return the site's logo URL, if any.
  s('mdl_output_get_logo_url', {
    t("$OUTPUT->get_logo_url("),
    i(1, "$maxwidth, $maxheight"),
    t(");"),
  }),

  -- Returns true is output has already started, and false if not.
  s('mdl_output_has_started', {
    t("$OUTPUT->has_started();"),
  }),

  -- Start output by sending the HTTP headers, and printing the HTML <head> and the start of the <body>.
  s('mdl_output_header', {
    t("$OUTPUT->header();"),
  }),

  -- Outputs a heading.
  s('mdl_output_heading', {
    t("$OUTPUT->heading("),
    i(1, "$text"),
    i(2, ", $level, $classes, $id"),
    t(");"),
  }),

  -- Centered heading with attached help button (same title text) and optional icon attached.
  s('mdl_output_heading_with_help', {
    t("$OUTPUT->heading_with_help("),
    i(1, "$text"),
    t(", "),
    i(2, "$helpidentifier"),
    i(3, ", $component, $icon, $iconalt, $level, $classnames"),
    t(");"),
  }),

  -- Returns HTML to display a help icon.
  s('mdl_output_help_icon', {
    t("$OUTPUT->help_icon("),
    i(1, "$identifier"),
    i(2, ", $component, $linktext"),
    t(");"),
  }),

  -- Returns HTML to display a scale help icon.
  s('mdl_output_help_icon_scale', {
    t("$OUTPUT->help_icon_scale("),
    i(1, "$courseid"),
    t(", "),
    i(2, "$scale_stdClass"),
    t(");"),
  }),

  -- Return the 'back' link that normally appears in the footer.
  s('mdl_output_home_link', {
    t("$OUTPUT->home_link();"),
  }),

  -- The attributes that should be added to the <html> tag. Designed to be called in theme layout.php files.
  s('mdl_output_htmlattributes', {
    t("$OUTPUT->htmlattributes();"),
  }),

  -- Internal implementation of file tree viewer items rendering.
  s('mdl_output_htmllize_file_tree', {
    t("$OUTPUT->htmllize_file_tree("),
    i(1, "$dir"),
    t(");"),
  }),

  -- Return HTML for an image_icon.
  s('mdl_output_image_icon', {
    t("$OUTPUT->image_icon("),
    i(1, "$pix"),
    t(", "),
    i(2, "$alt"),
    i(3, ", $component, $attributes_array"),
    t(");"),
  }),

  -- Return the moodle_url for an image.
  s('mdl_output_image_url', {
    t("$OUTPUT->image_url("),
    i(1, "$imagename"),
    i(2, ", $component"),
    t(");"),
  }),

  -- Returns HTML to display initials bar to provide access to other pages (usually in a search).
  s('mdl_output_initials_bar', {
    t("$OUTPUT->initials_bar("),
    i(1, "$current"),
    t(", "),
    i(2, "$class"),
    t(", "),
    i(3, "$title"),
    t(", "),
    i(4, "$urlvar"),
    t(", "),
    i(5, "$url"),
    i(6, ", $alpha"),
    t(");"),
  }),

  -- Does nothing. The maintenance renderer cannot produce language menus.
  s('mdl_output_lang_menu', {
    t("$OUTPUT->lang_menu();"),
  }),

  -- Accessibility: Left arrow-like character is used in the breadcrumb trail, course navigation menu (previous/next activity), calendar, and search forum block. If the theme does not set characters, appropriate defaults are set automatically.
  s('mdl_output_larrow', {
    t("$OUTPUT->larrow();"),
  }),

  -- Render the contents of a block_list.
  s('mdl_output_list_block_contents', {
    t("$OUTPUT->list_block_contents("),
    i(1, "$icons"),
    t(", "),
    i(2, "$items"),
    t(");"),
  }),

  -- Does nothing. The maintenance renderer has no need for login information.
  s('mdl_output_login_info', {
    t("$OUTPUT->login_info("),
    i(1, "$withlinks"),
    t(");"),
  }),

  -- Do NOT use, please use <?php echo $OUTPUT->main_content() ?> in layout files instead.
  s('mdl_output_main_content', {
    t("$OUTPUT->main_content();"),
  }),

  -- Scheduled maintenance warning message.
  s('mdl_output_maintenance_warning', {
    t("$OUTPUT->maintenance_warning();"),
  }),

  -- Renders an mform element from a template.
  s('mdl_output_mform_element', {
    t("$OUTPUT->mform_element("),
    i(1, "$HTML_QuickForm_element"),
    t(", "),
    i(2, "$required"),
    t(", "),
    i(3, "$advanced"),
    t(", "),
    i(4, "$error"),
    t(", "),
    i(5, "$ingroup"),
    t(");"),
  }),

  -- Return the navbar content so that it can be echoed out by the layout.
  s('mdl_output_navbar', {
    t("$OUTPUT->navbar();"),
  }),

  -- Allow plugins to provide some content to be rendered in the navbar. The plugin must define a PLUGIN_render_navbar_output function that returns the HTML they wish to add to the navbar.
  s('mdl_output_navbar_plugin_output', {
    t("$OUTPUT->navbar_plugin_output();"),
  }),

  -- Returns a template fragment representing a notification.
  s('mdl_output_notification', {
    t("$OUTPUT->notification("),
    i(1, "$message"),
    i(2, ", $type"),
    t(");"),
  }),

  -- Output a notification at a particular level - in this case, NOTIFY_MESSAGE.
  s('mdl_output_notify_message', {
    t("$OUTPUT->notify_message("),
    i(1, "$message"),
    t(");"),
  }),

  -- Output a notification at a particular level - in this case, NOTIFY_PROBLEM.
  s('mdl_output_notify_problem', {
    t("$OUTPUT->notify_problem("),
    i(1, "$message"),
    t(");"),
  }),

  -- Output a notification at a particular level - in this case, NOTIFY_REDIRECT.
  s('mdl_output_notify_redirect', {
    t("$OUTPUT->notify_redirect("),
    i(1, "$message"),
    t(");"),
  }),

  -- Output a notification at a particular level - in this case, NOTIFY_SUCCESS.
  s('mdl_output_notify_success', {
    t("$OUTPUT->notify_success("),
    i(1, "$message"),
    t(");"),
  }),

  -- Returns HTML to display a help icon.
  s('mdl_output_old_help_icon', {
    t("$OUTPUT->old_help_icon("),
    i(1, "$helpidentifier"),
    t(", "),
    i(2, "$title"),
    i(3, ", $component, $linktext"),
    t(");"),
  }),

  -- Returns the Moodle docs link to use for this page.
  s('mdl_output_page_doc_link', {
    t("$OUTPUT->page_doc_link("),
    i(1, "$text"),
    t(");"),
  }),

  -- Gets HTML for the page heading.
  s('mdl_output_page_heading', {
    t("$OUTPUT->page_heading("),
    i(1, "$tag"),
    t(");"),
  }),

  -- Gets the HTML for the page heading button.
  s('mdl_output_page_heading_button', {
    t("$OUTPUT->page_heading_button();"),
  }),

  -- Returns the page heading menu.
  s('mdl_output_page_heading_menu', {
    t("$OUTPUT->page_heading_menu();"),
  }),

  -- Returns the title to use on the page.
  s('mdl_output_page_title', {
    t("$OUTPUT->page_title();"),
  }),

  -- Returns HTML to display a single paging bar to provide access to other pages (usually in a search).
  s('mdl_output_paging_bar', {
    t("$OUTPUT->paging_bar("),
    i(1, "$totalcount"),
    t(", "),
    i(2, "$page"),
    t(", "),
    i(3, "$perpage"),
    t(", "),
    i(4, "$baseurl"),
    i(5, ", $pagevar"),
    t(");"),
  }),

  -- Return HTML for a pix_icon.
  s('mdl_output_pix_icon', {
    t("$OUTPUT->pix_icon("),
    i(1, "$pix"),
    t(", "),
    i(2, "$alt"),
    i(3, ", $component, $attributes_array"),
    t(");"),
  }),

  -- Return the direct URL for an image from the pix folder.
  s('mdl_output_pix_url', {
    t("$OUTPUT->pix_url("),
    i(1, "$imagename"),
    i(2, ", $component"),
    t(");"),
  }),

  -- Accessibility: Right arrow-like character is used in the breadcrumb trail, course navigation menu (previous/next activity), calendar, and search forum block. If the theme does not set characters, appropriate defaults are set automatically.
  s('mdl_output_rarrow', {
    t("$OUTPUT->rarrow();"),
  }),

  -- Used to display a redirection message.
  s('mdl_output_redirect_message', {
    t("$OUTPUT->redirect_message("),
    i(1, "$encodedurl"),
    t(", "),
    i(2, "$message"),
    t(", "),
    i(3, "$delay"),
    t(", "),
    i(4, "$debugdisableredirect"),
    i(5, ", $messagetype"),
    t(");"),
  }),

  -- Returns rendered widget.
  s('mdl_output_render', {
    t("$OUTPUT->render("),
    i(1, "$widget_renderable"),
    t(");"),
  }),

  -- Renders an action menu component.
  s('mdl_output_render_action_menu', {
    t("$OUTPUT->render_action_menu("),
    i(1, "$menu_action_menu"),
    t(");"),
  }),

  -- Renders a chart.
  s('mdl_output_render_chart', {
    t("$OUTPUT->render_chart("),
    i(1, "$chart_core_chart_base"),
    i(2, ", $withtable"),
    t(");"),
  }),

  -- Renders a bar chart.
  s('mdl_output_render_chart_bar', {
    t("$OUTPUT->render_chart_bar("),
    i(1, "$chart_core_chart_bar"),
    t(");"),
  }),

  -- Renders a line chart.
  s('mdl_output_render_chart_line', {
    t("$OUTPUT->render_chart_line("),
    i(1, "$chart_core_chart_line"),
    t(");"),
  }),

  -- Renders a pie chart.
  s('mdl_output_render_chart_pie', {
    t("$OUTPUT->render_chart_pie("),
    i(1, "$chart_core_chart_pie"),
    t(");"),
  }),

  -- Internal implementation of file picker rendering.
  s('mdl_output_render_file_picker', {
    t("$OUTPUT->render_file_picker("),
    i(1, "$file_picker"),
    t(");"),
  }),

  -- Renders a template by name with the given context. The provided data needs to be array/stdClass made up of only simple types. Simple types are array,stdClass,bool,int,float,string.
  s('mdl_output_render_from_template', {
    t("$OUTPUT->render_from_template("),
    i(1, "$templatename"),
    t(", "),
    i(2, "$context"),
    t(");"),
  }),

  -- Renders element for inline editing of any value.
  s('mdl_output_render_inplace_editable', {
    t("$OUTPUT->render_inplace_editable("),
    i(1, "$element_core_output_inplace_editable"),
    t(");"),
  }),

  -- Renders the login form.
  s('mdl_output_render_login', {
    t("$OUTPUT->render_login("),
    i(1, "$form_core_auth_output_login"),
    t(");"),
  }),

  -- Render the login signup form into a nice template for the theme.
  s('mdl_output_render_login_signup_form', {
    t("$OUTPUT->render_login_signup_form("),
    i(1, "$form"),
    t(");"),
  }),

  -- Renders preferences group.
  s('mdl_output_render_preferences_group', {
    t("$OUTPUT->render_preferences_group("),
    i(1, "$renderable_preferences_group"),
    t(");"),
  }),

  -- Renders preferences groups.
  s('mdl_output_render_preferences_groups', {
    t("$OUTPUT->render_preferences_groups("),
    i(1, "$renderable_preferences_groups"),
    t(");"),
  }),

  -- Renders a progress bar.
  s('mdl_output_render_progress_bar', {
    t("$OUTPUT->render_progress_bar("),
    i(1, "$progress_bar"),
    t(");"),
  }),

  -- Renders the skip links for the page.
  s('mdl_output_render_skip_links', {
    t("$OUTPUT->render_skip_links("),
    i(1, "$links"),
    t(");"),
  }),

  -- Returns a search box.
  s('mdl_output_search_box', {
    t("$OUTPUT->search_box("),
    i(1, "$id"),
    t(");"),
  }),

  -- Returns a form with a single button.
  s('mdl_output_single_button', {
    t("$OUTPUT->single_button("),
    i(1, "$url"),
    t(", "),
    i(2, "$label"),
    i(3, ", $method, $options_array"),
    t(");"),
  }),

  -- Returns a form with a single select widget.
  s('mdl_output_single_select', {
    t("$OUTPUT->single_select("),
    i(1, "$url"),
    t(", "),
    i(2, "$name"),
    t(", "),
    i(3, "$options_array"),
    i(4, ", $selected, $nothing, $formid, $attributes"),
    t(");"),
  }),

  -- Output the place a skip link goes to.
  s('mdl_output_skip_link_target', {
    t("$OUTPUT->skip_link_target("),
    i(1, "$id"),
    t(");"),
  }),

  -- Creates and returns a spacer image with optional line break.
  s('mdl_output_spacer', {
    t("$OUTPUT->spacer("),
    i(1, "$attributes_array, $br"),
    t(");"),
  }),

  -- The standard tags (typically script tags that are not needed earlier) that should be output after everything else. Designed to be called in theme layout.php files.
  s('mdl_output_standard_end_of_body_html', {
    t("$OUTPUT->standard_end_of_body_html();"),
  }),

  -- The standard tags (typically performance information and validation links, if we are in developer debug mode) that should be output in the footer area of the page. Designed to be called in theme layout.php files.
  s('mdl_output_standard_footer_html', {
    t("$OUTPUT->standard_footer_html();"),
  }),

  -- The standard tags (meta tags, links to stylesheets and JavaScript, etc.) that should be included in the <head> tag. Designed to be called in theme layout.php files.
  s('mdl_output_standard_head_html', {
    t("$OUTPUT->standard_head_html();"),
  }),

  -- The standard tags (typically skip links) that should be output just inside the start of the <body> tag. Designed to be called in theme layout.php files.
  s('mdl_output_standard_top_of_body_html', {
    t("$OUTPUT->standard_top_of_body_html();"),
  }),

  -- Displays the list of tags associated with an entry.
  s('mdl_output_tag_list', {
    t("$OUTPUT->tag_list("),
    i(1, "$tags"),
    i(2, ", $label, $classes, $limit, $pagecontext"),
    t(");"),
  }),

  -- Make nested HTML lists out of the items.
  s('mdl_output_tree_block_contents', {
    t("$OUTPUT->tree_block_contents("),
    i(1, "$items"),
    i(2, ", $attrs_array"),
    t(");"),
  }),

  -- Accessibility: Up arrow-like character is used in the book heirarchical navigation. If the theme does not set characters, appropriate defaults are set automatically.
  s('mdl_output_uarrow', {
    t("$OUTPUT->uarrow();"),
  }),

  -- Returns HTML to display the 'Update this Modulename' button that appears on module pages.
  s('mdl_output_update_module_button', {
    t("$OUTPUT->update_module_button("),
    i(1, "$cmid"),
    t(", "),
    i(2, "$modulename"),
    t(");"),
  }),

  -- Returns a form with a url select widget.
  s('mdl_output_url_select', {
    t("$OUTPUT->url_select("),
    i(1, "$urls_array"),
    t(", "),
    i(2, "$selected"),
    i(3, ", $nothing, $formid"),
    t(");"),
  }),

  -- Construct a user menu, returning HTML that can be echoed out by a layout file.
  s('mdl_output_user_menu', {
    t("$OUTPUT->user_menu("),
    i(1, "$user, $withlinks"),
    t(");"),
  }),

  -- Does nothing. The maintenance renderer cannot produce user pictures.
  s('mdl_output_user_picture', {
    t("$OUTPUT->user_picture("),
    i(1, "$user_stdClass"),
    i(2, ", $options_array"),
    t(");"),
  }),

  -- Given an array or space-separated list of classes, prepares and returns the HTML class attribute value.
  s('mdl_output_prepare_classes', {
    t("$OUTPUT::prepare_classes("),
    i(1, "$classes"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_output_label', {
    t("$OUTPUT->label("),
    i(1, "html_label $label"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_output_link', {
    t("$OUTPUT->link("),
    i(1, "$link"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_output_image', {
    t("$OUTPUT->image();"),
  }),

  -- Moodle snippets
  s('mdl_output_form', {
    t("$OUTPUT->form("),
    i(1, "$form"),
    t(", "),
    i(2, " $contents"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_output_button', {
    t("$OUTPUT->button("),
    i(1, "$formwithbutton"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_output_htmllist', {
    t("$OUTPUT->htmllist("),
    i(1, "$list"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_output_select', {
    t("$OUTPUT->select("),
    i(1, "$select"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_output_checkbox', {
    t("$OUTPUT->checkbox("),
    i(1, "$checkbox"),
    t(", "),
    i(2, " 'donotask'"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_output_old_icon_url', {
    t("$OUTPUT->old_icon_url("),
    i(1, "'moodlelogo'"),
    t(");"),
  }),

  -- Force the settings menu to be displayed on this page. This will only force the settings menu on an activity / resource page that is being displayed on a theme that uses a settings menu.
  s('mdl_page_force_settings_menu', {
    t("$PAGE->force_settings_menu("),
    i(1, "$forced"),
    t(");"),
  }),

  -- Check to see if the settings menu is forced to display on this activity / resource page. This only applies to themes that use the settings menu.
  s('mdl_page_is_settings_menu_forced', {
    t("$PAGE->is_settings_menu_forced();"),
  }),

  -- Returns instance of page renderer
  s('mdl_page_get_renderer', {
    t("$PAGE->get_renderer("),
    i(1, "$component"),
    i(2, ", $subtype, $target"),
    t(");"),
  }),

  -- Checks to see if there are any items on the navbar object
  s('mdl_page_has_navbar', {
    t("$PAGE->has_navbar();"),
  }),

  -- Switches from the regular requirements manager to the fragment requirements manager to capture all necessary JavaScript to display a chunk of HTML such as an mform. This is for use by the get_fragment() web service and not for use elsewhere.
  s('mdl_page_start_collecting_javascript_requirements', {
    t("$PAGE->start_collecting_javascript_requirements();"),
  }),

  -- Switches back from collecting fragment JS requirement to the original requirement manager
  s('mdl_page_end_collecting_javascript_requirements', {
    t("$PAGE->end_collecting_javascript_requirements();"),
  }),

  -- Should the current user see this page in editing mode. That is, are they allowed to edit this page, and are they currently in editing mode.
  s('mdl_page_user_is_editing', {
    t("$PAGE->user_is_editing();"),
  }),

  -- Does the user have permission to edit blocks on this page.
  s('mdl_page_user_can_edit_blocks', {
    t("$PAGE->user_can_edit_blocks();"),
  }),

  -- Does the user have permission to see this page in editing mode.
  s('mdl_page_user_allowed_editing', {
    t("$PAGE->user_allowed_editing();"),
  }),

  -- Get a description of this page. Normally displayed in the footer in developer debug mode.
  s('mdl_page_debug_summary', {
    t("$PAGE->debug_summary();"),
  }),

  -- Set the state.
  s('mdl_page_set_state', {
    t("$PAGE->set_state(${1|STATE_BEFORE_HEADER,STATE_PRINTING_HEADER,STATE_IN_BODY,STATE_DONE|});"),
  }),

  -- Set the current course. This sets both $PAGE->course and $COURSE. It also sets the right theme and locale.
  s('mdl_page_set_course', {
    t("$PAGE->set_course("),
    i(1, "$course"),
    t(");"),
  }),

  -- Set the main context to which this page belongs.
  s('mdl_page_set_context', {
    t("$PAGE->set_context("),
    i(1, "$context"),
    t(");"),
  }),

  -- The course module that this page belongs to (if it does belong to one).
  s('mdl_page_set_cm', {
    t("$PAGE->set_cm("),
    i(1, "$cm"),
    i(2, ", $course, $module"),
    t(");"),
  }),

  -- Sets the activity record. This could be a row from the main table for a module. For instance if the current module (cm) is a forum this should be a row from the forum table.
  s('mdl_page_set_activity_record', {
    t("$PAGE->set_activity_record("),
    i(1, "$module"),
    t(");"),
  }),

  -- Sets the pagetype to use for this page.
  s('mdl_page_set_pagetype', {
    t("$PAGE->set_pagetype("),
    i(1, "$pagetype"),
    t(");"),
  }),

  -- Sets the layout to use for this page.
  s('mdl_page_set_pagelayout', {
    t("$PAGE->set_pagelayout("),
    i(1, "$pagelayout"),
    t(");"),
  }),

  -- If context->id and pagetype are not enough to uniquely identify this page, then you can set a subpage id as well. For example, the tags page sets
  s('mdl_page_set_subpage', {
    t("$PAGE->set_subpage("),
    i(1, "$subpage"),
    t(");"),
  }),

  -- Adds a CSS class to the body tag of the page.
  s('mdl_page_add_body_class', {
    t("$PAGE->add_body_class("),
    i(1, "$class"),
    t(");"),
  }),

  -- Adds an array of body classes to the body tag of this page.
  s('mdl_page_add_body_classes', {
    t("$PAGE->add_body_classes("),
    i(1, "$classes"),
    t(");"),
  }),

  -- Sets the title for the page. This is normally used within the title tag in the head of the page.
  s('mdl_page_set_title', {
    t("$PAGE->set_title("),
    i(1, "$title"),
    t(");"),
  }),

  -- Sets the heading to use for the page. This is normally used as the main heading at the top of the content.
  s('mdl_page_set_heading', {
    t("$PAGE->set_heading("),
    i(1, "$heading"),
    t(");"),
  }),

  -- Sets some HTML to use next to the heading {@link moodle_page::set_heading()}
  s('mdl_page_set_headingmenu', {
    t("$PAGE->set_headingmenu("),
    i(1, "$menu"),
    t(");"),
  }),

  -- Set the course category this page belongs to manually.
  s('mdl_page_set_category_by_id', {
    t("$PAGE->set_category_by_id("),
    i(1, "$categoryid"),
    t(");"),
  }),

  -- Set a different path to use for the 'Moodle docs for this page' link.
  s('mdl_page_set_docs_path', {
    t("$PAGE->set_docs_path("),
    i(1, "$path"),
    t(");"),
  }),

  -- You should call this method from every page to set the URL that should be used to return to this page.
  s('mdl_page_set_url', {
    t("$PAGE->set_url("),
    i(1, "$url"),
    i(2, ", $params_array"),
    t(");"),
  }),

  -- Make sure page URL does not contain the given URL parameter.
  s('mdl_page_ensure_param_not_in_url', {
    t("$PAGE->ensure_param_not_in_url("),
    i(1, "$param"),
    t(");"),
  }),

  -- Sets an alternative version of this page.
  s('mdl_page_add_alternate_version', {
    t("$PAGE->add_alternate_version("),
    i(1, "$title"),
    t(", "),
    i(2, "$url"),
    t(", "),
    i(3, "$mimetype"),
    t(");"),
  }),

  -- Specify a form control should be focused when the page has loaded.
  s('mdl_page_set_focuscontrol', {
    t("$PAGE->set_focuscontrol("),
    i(1, "$controlid"),
    t(");"),
  }),

  -- Specify a fragment of HTML that goes where the 'Turn editing on' button normally goes.
  s('mdl_page_set_button', {
    t("$PAGE->set_button("),
    i(1, "$html"),
    t(");"),
  }),

  -- Set the capability that allows users to edit blocks on this page.
  s('mdl_page_set_blocks_editing_capability', {
    t("$PAGE->set_blocks_editing_capability("),
    i(1, "$capability"),
    t(");"),
  }),

  -- Some pages let you turn editing on for reasons other than editing blocks.
  s('mdl_page_set_other_editing_capability', {
    t("$PAGE->set_other_editing_capability("),
    i(1, "$capability"),
    t(");"),
  }),

  -- Sets whether the browser should cache this page or not.
  s('mdl_page_set_cacheable', {
    t("$PAGE->set_cacheable("),
    i(1, "$cacheable"),
    t(");"),
  }),

  -- Sets the page to periodically refresh
  s('mdl_page_set_periodic_refresh_delay', {
    t("$PAGE->set_periodic_refresh_delay("),
    i(1, "$delay"),
    t(");"),
  }),

  -- Force this page to use a particular theme.
  s('mdl_page_force_theme', {
    t("$PAGE->force_theme("),
    i(1, "$themename"),
    t(");"),
  }),

  -- Reload theme settings.
  s('mdl_page_reload_theme', {
    t("$PAGE->reload_theme();"),
  }),

  -- @DEPRECATED SINCE MOODLE 3.4 MDL-42834. This function indicates that current page requires the https when $CFG->loginhttps enabled.
  s('mdl_page_https_required', {
    t("$PAGE->https_required();"),
  }),

  -- @DEPRECATED SINCE MOODLE 3.4 MDL-42834. Makes sure that page previously marked with https_required() is really using https://, if not it redirects to https://
  s('mdl_page_verify_https_required', {
    t("$PAGE->verify_https_required();"),
  }),

  -- Method for use by Moodle core to set up the theme. Do not use this in your own code.
  s('mdl_page_initialise_theme_and_output', {
    t("$PAGE->initialise_theme_and_output();"),
  }),

  -- Reset the theme and output for a new context. This only makes sense from external::validate_context(). Do not cheat.
  s('mdl_page_reset_theme_and_output', {
    t("$PAGE->reset_theme_and_output();"),
  }),

  -- Returns true if the page URL has beem set.
  s('mdl_page_has_set_url', {
    t("$PAGE->has_set_url();"),
  }),

  -- Gets set when the block actions for the page have been processed.
  s('mdl_page_set_block_actions_done', {
    t("$PAGE->set_block_actions_done("),
    i(1, "$setting"),
    t(" );"),
  }),

  -- Are popup notifications allowed on this page? Popup notifications may be disallowed in situations such as while upgrading or completing a quiz
  s('mdl_page_get_popup_notification_allowed', {
    t("$PAGE->get_popup_notification_allowed();"),
  }),

  -- Allow or disallow popup notifications on this page. Popups are allowed by default.
  s('mdl_page_set_popup_notification_allowed', {
    t("$PAGE->set_popup_notification_allowed("),
    i(1, "$allowed"),
    t(");"),
  }),

  -- Returns the block region having made any required theme manipulations.
  s('mdl_page_apply_theme_region_manipulations', {
    t("$PAGE->apply_theme_region_manipulations("),
    i(1, "$region"),
    t(");"),
  }),

  -- Add a report node and a specific report to the navigation.
  s('mdl_page_add_report_nodes', {
    t("$PAGE->add_report_nodes("),
    i(1, "$userid"),
    t(", "),
    i(2, "$nodeinfo"),
    t(");"),
  }),

  -- Returns integer one of the STATE_XXX constants. You should not normally need to use this in your code. It is intended for internal use by this class and its friends like print_header, to check that everything is working as expected. Also accessible as $PAGE->state.
  s('mdl_page_state', {
    t("$PAGE->state"),
  }),

  -- Returns bool has the header already been printed?
  s('mdl_page_headerprinted', {
    t("$PAGE->headerprinted"),
  }),

  -- Returns stdClass the current course that we are inside - a row from the course table. (Also available as $COURSE global.) If we are not inside an actual course, this will be the site course.
  s('mdl_page_course', {
    t("$PAGE->course"),
  }),

  -- Returns cm_info the course_module that this page belongs to. Will be null if this page is not within a module. This is a full cm object, as loaded by get_coursemodule_from_id or get_coursemodule_from_instance, so the extra modname and name fields are present.
  s('mdl_page_cm', {
    t("$PAGE->cm"),
  }),

  -- Returns stdClass the row from the activities own database table (for example the forum or quiz table) that this page belongs to. Will be null if this page is not within a module.
  s('mdl_page_activityrecord', {
    t("$PAGE->activityrecord"),
  }),

  -- Returns string the The type of activity we are in, for example 'forum' or 'quiz'. Will be null if this page is not within a module.
  s('mdl_page_activityname', {
    t("$PAGE->activityname"),
  }),

  -- Returns stdClass the category that the page course belongs to. If there isn't one (that is, if this is the front page course) returns null.
  s('mdl_page_category', {
    t("$PAGE->category"),
  }),

  -- Returns array an array of all the categories the page course belongs to, starting with the immediately containing category, and working out to the top-level category. This may be the empty array if we are in the front page course.
  s('mdl_page_categories', {
    t("$PAGE->categories"),
  }),

  -- Returns context the main context to which this page belongs.
  s('mdl_page_context', {
    t("$PAGE->context"),
  }),

  -- Returns string e.g. 'my-index' or 'mod-quiz-attempt'.
  s('mdl_page_pagetype', {
    t("$PAGE->pagetype"),
  }),

  -- Returns string The id to use on the body tag, uses {@link magic_get_pagetype()}.
  s('mdl_page_bodyid', {
    t("$PAGE->bodyid"),
  }),

  -- Returns string the general type of page this is. For example 'standard', 'popup', 'home'. Allows the theme to display things differently, if it wishes to.
  s('mdl_page_pagelayout', {
    t("$PAGE->pagelayout"),
  }),

  -- Returns array returns arrays with options for layout file
  s('mdl_page_layout_options', {
    t("$PAGE->layout_options"),
  }),

  -- Returns string The subpage identifier, if any.
  s('mdl_page_subpage', {
    t("$PAGE->subpage"),
  }),

  -- Returns string the class names to put on the body element in the HTML.
  s('mdl_page_bodyclasses', {
    t("$PAGE->bodyclasses"),
  }),

  -- Returns string the title that should go in the <head> section of the HTML of this page.
  s('mdl_page_title', {
    t("$PAGE->title"),
  }),

  -- Returns string the main heading that should be displayed at the top of the <body>.
  s('mdl_page_heading', {
    t("$PAGE->heading"),
  }),

  -- Returns string The menu (or actions) to display in the heading
  s('mdl_page_headingmenu', {
    t("$PAGE->headingmenu"),
  }),

  -- Returns string the path to the Moodle docs for this page.
  s('mdl_page_docspath', {
    t("$PAGE->docspath"),
  }),

  -- Returns moodle_url the clean URL required to load the current page. (You should normally use this in preference to $ME or $FULLME.)
  s('mdl_page_url', {
    t("$PAGE->url"),
  }),

  -- The list of alternate versions of this page. Array mime type => object with ->url and ->title.
  s('mdl_page_alternateversions', {
    t("$PAGE->alternateversions"),
  }),

  -- Returns block_manager the blocks manager object for this page.
  s('mdl_page_blocks', {
    t("$PAGE->blocks"),
  }),

  -- Return the safe config values that get set for javascript in "M.cfg".
  s('mdl_page_requires_get_config_for_javascript', {
    t("$PAGE->requires->get_config_for_javascript("),
    i(1, "$moodle_page"),
    t(", "),
    i(2, "$renderer"),
    t(");"),
  }),

  -- Ensure that the specified JavaScript file is linked to from this page. NOTE: This function is to be used in RARE CASES ONLY, please store your JS in module.js file and use $PAGE->requires->js_init_call() instead or use /yui/ subdirectories for YUI modules.
  s('mdl_page_requires_js', {
    t("$PAGE->requires->js("),
    i(1, "$url"),
    i(2, ", $inhead"),
    t(");"),
  }),

  -- Request inclusion of jQuery library in the page. NOTE: this should not be used in official Moodle distribution!
  s('mdl_page_requires_', {
    t("$PAGE->requires->jquery();"),
  }),

  -- Request inclusion of jQuery plugin.
  s('mdl_page_requires_jquery_plugin', {
    t("$PAGE->requires->jquery_plugin("),
    i(1, "$plugin"),
    i(2, ", $component"),
    t(");"),
  }),

  -- Request replacement of one jQuery plugin by another. This is useful when themes want to replace the jQuery UI theme, the problem is that theme can not prevent others from including the core ui-css plugin.
  s('mdl_page_requires_jquery_override_plugin', {
    t("$PAGE->requires->jquery_override_plugin("),
    i(1, "$oldplugin"),
    t(", "),
    i(2, "$newplugin"),
    t(");"),
  }),

  -- Append YUI3 module to default YUI3 JS loader. The structure of module array is described at {@link http://developer.yahoo.com/yui/3/yui/}
  s('mdl_page_requires_js_module', {
    t("$PAGE->requires->js_module("),
    i(1, "$module"),
    t(");"),
  }),

  -- Ensure that the specified CSS file is linked to from this page.
  s('mdl_page_requires_css', {
    t("$PAGE->requires->css("),
    i(1, "$stylesheet"),
    t(");"),
  }),

  -- Add theme stylesheet to page - do not use from plugin code, this should be called only from the core renderer!
  s('mdl_page_requires_css_theme', {
    t("$PAGE->requires->css_theme("),
    i(1, "$stylesheet_moodle_url"),
    t(");"),
  }),

  -- Ensure that a skip link to a given target is printed at the top of the <body>. You must call this function before {@link get_top_of_body_code()}
  s('mdl_page_requires_skip_link_to', {
    t("$PAGE->requires->skip_link_to("),
    i(1, "$target"),
    t(", "),
    i(2, "$linktext"),
    t(");"),
  }),

  -- This function appends a block of code to the AMD specific javascript block executed in the page footer, just after loading the requirejs library. The code passed here can rely on AMD module loading, e.g. require('jquery', function(${1:\$)} {...});
  s('mdl_page_requires_js_amd_inline', {
    t("$PAGE->requires->js_amd_inline("),
    i(1, "$code"),
    t(");"),
  }),

  -- This function creates a minimal JS script that requires and calls a single function from an AMD module with arguments. If it is called multiple times, it will be executed multiple times.
  s('mdl_page_requires_js_call_amd', {
    t("$PAGE->requires->js_call_amd("),
    i(1, "$fullmodule"),
    t(", "),
    i(2, "$func"),
    i(3, ", $params"),
    t(");"),
  }),

  -- Creates a JavaScript function call that requires one or more modules to be loaded. This function can be used to include all of the standard YUI module types within JavaScript
  s('mdl_page_requires_yui_module', {
    t("$PAGE->requires->yui_module("),
    i(1, "$modules"),
    t(", "),
    i(2, "$function"),
    t(","),
    i(3, " $arguments_array, $galleryversion, $ondomready"),
    t(");"),
  }),

  -- Set the CSS Modules to be included from YUI.
  s('mdl_page_requires_set_yuicssmodules', {
    t("$PAGE->requires->set_yuicssmodules("),
    i(1, "$modules_array"),
    t(");"),
  }),

  -- Ensure that the specified JavaScript function is called from an inline script from page footer.
  s('mdl_page_requires_js_init_call', {
    t("$PAGE->requires->js_init_call("),
    i(1, "$function"),
    i(2, ", $extraarguments_array, $ondomready, $module_array"),
    t(");"),
  }),

  -- Add short static javascript code fragment to page footer. This is intended primarily for loading of js modules and initialising page layout. Ideally the JS code fragment should be stored in plugin renderer so that themes may override it.
  s('mdl_page_requires_js_init_code', {
    t("$PAGE->requires->js_init_code("),
    i(1, "$jscode"),
    i(2, ", $ondomready, $module_array"),
    t(");"),
  }),

  -- Make a language string available to JavaScript. All the strings will be available in a M.str object in the global namespace. So, for example, after a call to $PAGE->requires->string_for_js('course', 'moodle'); then the JavaScript variable M.str.moodle.course will be 'Course', or the equivalent in the current language.
  s('mdl_page_requires_string_for_js', {
    t("$PAGE->requires->string_for_js("),
    i(1, "$identifier"),
    t(", "),
    i(2, "$component"),
    i(3, ", $a"),
    t(");"),
  }),

  -- Make an array of language strings available for JS. This function calls the above function {@link string_for_js()} for each requested string in the $identifiers array that is passed to the argument for a single module passed in $module.
  s('mdl_page_requires_strings_for_js', {
    t("$PAGE->requires->strings_for_js("),
    i(1, "$identifiers"),
    t(", "),
    i(2, "$component"),
    i(3, ", $a"),
    t(");"),
  }),

  -- Creates a YUI event handler.
  s('mdl_page_requires_event_handler', {
    t("$PAGE->requires->event_handler("),
    i(1, "$selector"),
    t(", "),
    i(2, "$event"),
    t(", "),
    i(3, "$function"),
    i(4, ", $arguments_array"),
    t(");"),
  }),

  -- Generate any HTML that needs to go inside the <head> tag. Normally, this method is called automatically by the code that prints the <head> tag. You should not normally need to call it in your own code.
  s('mdl_page_requires_get_head_code', {
    t("$PAGE->requires->get_head_code("),
    i(1, "$moodle_page"),
    t(", "),
    i(2, "$renderer"),
    t(");"),
  }),

  -- Generate any HTML that needs to go at the start of the <body> tag. Normally, this method is called automatically by the code that prints the <head> tag. You should not normally need to call it in your own code.
  s('mdl_page_requires_get_top_of_body_code', {
    t("$PAGE->requires->get_top_of_body_code("),
    i(1, "$renderer"),
    t(");"),
  }),

  -- Generate any HTML that needs to go at the end of the page. Normally, this method is called automatically by the code that prints the page footer. You should not normally need to call it in your own code.
  s('mdl_page_requires_get_end_code', {
    t("$PAGE->requires->()get_end_code;"),
  }),

  -- Have we already output the code in the <head> tag?
  s('mdl_page_requires_is_head_done', {
    t("$PAGE->requires->()is_head_done;"),
  }),

  -- Have we already output the code at the start of the <body> tag?
  s('mdl_page_requires_is_top_of_body_done', {
    t("$PAGE->requires->()is_top_of_body_done;"),
  }),

  -- Should we generate a bit of content HTML that is only required once on this page (e.g. the contents of the modchooser), now? Basically, we call {@link has_one_time_item_been_created()}, and if the thing has not already been output, we return true to tell the caller to generate it, and also call {@link set_one_time_item_created()} to record the fact that it is about to be generated.
  s('mdl_page_requires_should_create_one_time_item_now', {
    t("$PAGE->requires->should_create_one_time_item_now("),
    i(1, "$thing"),
    t(");"),
  }),

  -- Has a particular bit of HTML that is only required once on this page (e.g. the contents of the modchooser) already been generated? Normally, you can use the {@link should_create_one_time_item_now()} helper method rather than calling this method directly.
  s('mdl_page_requires_has_one_time_item_been_created', {
    t("$PAGE->requires->has_one_time_item_been_created("),
    i(1, "$thing"),
    t(");"),
  }),

  -- Indicate that a particular bit of HTML that is only required once on this page (e.g. the contents of the modchooser) has been generated (or is about to be)? Normally, you can use the {@link should_create_one_time_item_now()} helper method rather than calling this method directly.
  s('mdl_page_requires_set_one_time_item_created', {
    t("$PAGE->requires->set_one_time_item_created("),
    i(1, "$thing"),
    t(");"),
  }),

  -- Returns bool can this page be cached by the user's browser.
  s('mdl_page_cacheable', {
    t("$PAGE->cacheable"),
  }),

  -- Returns string the id of the HTML element to be focused when the page has loaded.
  s('mdl_page_focuscontrol', {
    t("$PAGE->focuscontrol"),
  }),

  -- Returns string the HTML to go where the Turn editing on button normally goes.
  s('mdl_page_button', {
    t("$PAGE->button"),
  }),

  -- Returns theme_config the initialised theme for this page.
  s('mdl_page_theme', {
    t("$PAGE->theme"),
  }),

  -- Returns an array of minipulations or false if there are none to make.
  s('mdl_page_blockmanipulations', {
    t("$PAGE->blockmanipulations"),
  }),

  -- Returns string The device type being used.
  s('mdl_page_devicetypeinuse', {
    t("$PAGE->devicetypeinuse"),
  }),

  -- Returns int The periodic refresh delay to use with meta refresh
  s('mdl_page_periodicrefreshdelay', {
    t("$PAGE->periodicrefreshdelay"),
  }),

  -- Returns xhtml_container_stack tracks XHTML tags on this page that have been opened but not closed. Mainly for internal use by the rendering code.
  s('mdl_page_opencontainers', {
    t("$PAGE->opencontainers"),
  }),

  -- Return the navigation object - global_navigation.
  s('mdl_page_navigation', {
    t("$PAGE->navigation"),
  }),

  -- Return a navbar object
  s('mdl_page_navbar', {
    t("$PAGE->navbar"),
  }),

  -- Returns the settings navigation object
  s('mdl_page_settingsnav', {
    t("$PAGE->settingsnav"),
  }),

  -- Returns the flat navigation object
  s('mdl_page_flatnav', {
    t("$PAGE->flatnav"),
  }),

  -- Returns request IP address.
  s('mdl_page_requestip', {
    t("$PAGE->requestip"),
  }),

  -- Returns the origin of current request. Note: constants are not required because we need to use these values in logging and reports.
  s('mdl_page_requestorigin', {
    t("$PAGE->requestorigin"),
  }),

  -- Moodle snippets
  s('mdl_page_navbar_ignore_active', {
    t("$PAGE->navbar->ignore_active();"),
  }),

  -- Moodle snippets
  s('mdl_page_navbar_add', {
    t("$PAGE->navbar->add("),
    i(1, "get_string('name of thing')"),
    t(", "),
    i(2, " new moodle_url('/a/link/if/you/want/one.php')"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_page_settingsnav_add', {
    t("$PAGE->settingsnav->add("),
    i(1, "get_string('setting')"),
    t(", "),
    i(2, " new moodle_url('/a/link/if/you/want/one.php')"),
    t(", "),
    i(3, " navigation_node::TYPE_CONTAINER"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_page_navigation_find', {
    t("$PAGE->navigation->find("),
    i(1, "$courseid"),
    t(", "),
    i(2, " navigation_node::TYPE_COURSE"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_page_requires', {
    t("$PAGE->requires"),
  }),

  -- The user ID.
  s('mdl_user_id', {
    t("$USER->id"),
  }),

  -- The authentication plugin used for this user record.
  s('mdl_user_auth', {
    t("$USER->auth"),
  }),

  -- If this is an active user or not.
  s('mdl_user_confirmed', {
    t("$USER->confirmed"),
  }),

  -- A flag to determine if the user has agreed to the site policy.
  s('mdl_user_policyagreed', {
    t("$USER->policyagreed"),
  }),

  -- A flag to show if the user has been deleted or not.
  s('mdl_user_deleted', {
    t("$USER->deleted"),
  }),

  -- A flag to show if the user has been suspended on this system.
  s('mdl_user_suspended', {
    t("$USER->suspended"),
  }),

  -- An identifier for the MNet host if used.
  s('mdl_user_mnethostid', {
    t("$USER->mnethostid"),
  }),

  -- The username for this user.
  s('mdl_user_username', {
    t("$USER->username"),
  }),

  -- An identification number given by the institution.
  s('mdl_user_idnumber', {
    t("$USER->idnumber"),
  }),

  -- The first name of the user.
  s('mdl_user_firstname', {
    t("$USER->firstname"),
  }),

  -- The surname of the user.
  s('mdl_user_lastname', {
    t("$USER->lastname"),
  }),

  -- An email address for contact.
  s('mdl_user_email', {
    t("$USER->email"),
  }),

  -- A preference to disable notifications from being sent to the user.
  s('mdl_user_emailstop', {
    t("$USER->emailstop"),
  }),

  -- The ICQ number of the user.
  s('mdl_user_icq', {
    t("$USER->icq"),
  }),

  -- The Skype identifier of the user.
  s('mdl_user_skype', {
    t("$USER->skype"),
  }),

  -- The Yahoo identifier of the user.
  s('mdl_user_yahoo', {
    t("$USER->yahoo"),
  }),

  -- The AIM identifier of the user.
  s('mdl_user_aim', {
    t("$USER->aim"),
  }),

  -- The MSN identifier of the user.
  s('mdl_user_msn', {
    t("$USER->msn"),
  }),

  -- The institution that this user is a member of.
  s('mdl_user_institution', {
    t("$USER->institution"),
  }),

  -- The department that this user can be found in.
  s('mdl_user_department', {
    t("$USER->department"),
  }),

  -- The address of the user.
  s('mdl_user_address', {
    t("$USER->address"),
  }),

  -- The city of the user.
  s('mdl_user_city', {
    t("$USER->city"),
  }),

  -- The country that the user is in.
  s('mdl_user_country', {
    t("$USER->country"),
  }),

  -- A user preference for the language shown.
  s('mdl_user_lang', {
    t("$USER->lang"),
  }),

  -- A user preference for the type of calendar to use.
  s('mdl_user_calendartype', {
    t("$USER->calendartype"),
  }),

  -- A user preference for the theme to display.
  s('mdl_user_theme', {
    t("$USER->theme"),
  }),

  -- The timezone of the user.
  s('mdl_user_timezone', {
    t("$USER->timezone"),
  }),

  -- The time that this user first accessed the site.
  s('mdl_user_firstaccess', {
    t("$USER->firstaccess"),
  }),

  -- The time that the user last accessed the site.
  s('mdl_user_lastaccess', {
    t("$USER->lastaccess"),
  }),

  -- The last login of this user.
  s('mdl_user_lastlogin', {
    t("$USER->lastlogin"),
  }),

  -- The current login for this user.
  s('mdl_user_currentlogin', {
    t("$USER->currentlogin"),
  }),

  -- The last IP address for the user.
  s('mdl_user_lastip', {
    t("$USER->lastip"),
  }),

  -- Secret.. not sure.
  s('mdl_user_secret', {
    t("$USER->secret"),
  }),

  -- The picture details associated with this user.
  s('mdl_user_picture', {
    t("$USER->picture"),
  }),

  -- A URL related to this user.
  s('mdl_user_url', {
    t("$USER->url"),
  }),

  -- A setting for the mail digest for this user.
  s('mdl_user_maildigest', {
    t("$USER->maildigest"),
  }),

  -- A preference as to if the user should be auto-subscribed to forums the user posts in.
  s('mdl_user_autosubscribe', {
    t("$USER->autosubscribe"),
  }),

  -- A preference for forums and tracking them.
  s('mdl_user_trackforums', {
    t("$USER->trackforums"),
  }),

  -- The time this record was created.
  s('mdl_user_timecreated', {
    t("$USER->timecreated"),
  }),

  -- The time when the record was modified.
  s('mdl_user_timemodified', {
    t("$USER->timemodified"),
  }),

  -- The trust bit mask.
  s('mdl_user_trustbitmask', {
    t("$USER->trustbitmask"),
  }),

  -- Alternative text for the user\'s image.
  s('mdl_user_imagealt', {
    t("$USER->imagealt"),
  }),

  -- The phonetic details about the user\'s surname.
  s('mdl_user_lastnamephonetic', {
    t("$USER->lastnamephonetic"),
  }),

  -- The phonetic details about the user\'s first name.
  s('mdl_user_firstnamephonetic', {
    t("$USER->firstnamephonetic"),
  }),

  -- The middle name of the user.
  s('mdl_user_middlename', {
    t("$USER->middlename"),
  }),

  -- An alternative name for the user.
  s('mdl_user_alternatename', {
    t("$USER->alternatename"),
  }),

  -- The MoodleNet profile for the user.
  s('mdl_user_moodlenetprofile', {
    t("$USER->moodlenetprofile"),
  }),

  -- The session key.
  s('mdl_user_sesskey', {
    t("$USER->sesskey"),
  }),

  -- Returns a particular value for the named variable, taken from POST or GET. If the parameter doesn't exist then an error is thrown because we require this variable. This function should be used to initialise all required values in a script that are based on parameters.
  s('mdl_required_param', {
    t("required_param("),
    i(1, "$parameter_name"),
    t(", ${2|PARAM_INT,PARAM_TEXT,PARAM_BOOL,PARAM_ALPHA,PARAM_ALPHAEXT,PARAM_ALPHANUM,PARAM_ALPHANUMEXT,PARAM_AUTH,PARAM_BASE64,PARAM_CAPABILITY,PARAM_CLEANHTML,PARAM_EMAIL,PARAM_FILE,PARAM_FLOAT,PARAM_HOST,PARAM_LANG,PARAM_LOCALURL,PARAM_NOTAGS,PARAM_PATH,PARAM_PEM,PARAM_PERMISSION,PARAM_RAW,PARAM_RAW_TRIMMED,PARAM_SAFEDIR,PARAM_SAFEPATH,PARAM_SEQUENCE,PARAM_STRINGID,PARAM_TAG,PARAM_TAGLIST,PARAM_THEME,PARAM_URL,PARAM_USERNAME|});"),
  }),

  -- Returns a particular array value for the named variable, taken from POST or GET. This function should be used to initialise all required values in a script that are based on parameters.
  s('mdl_required_param_array', {
    t("required_param_array("),
    i(1, "$parameter_name"),
    t(", ${2|PARAM_INT,PARAM_TEXT,PARAM_BOOL,PARAM_ALPHA,PARAM_ALPHAEXT,PARAM_ALPHANUM,PARAM_ALPHANUMEXT,PARAM_AUTH,PARAM_BASE64,PARAM_CAPABILITY,PARAM_CLEANHTML,PARAM_EMAIL,PARAM_FILE,PARAM_FLOAT,PARAM_HOST,PARAM_LANG,PARAM_LOCALURL,PARAM_NOTAGS,PARAM_PATH,PARAM_PEM,PARAM_PERMISSION,PARAM_RAW,PARAM_RAW_TRIMMED,PARAM_SAFEDIR,PARAM_SAFEPATH,PARAM_SEQUENCE,PARAM_STRINGID,PARAM_TAG,PARAM_TAGLIST,PARAM_THEME,PARAM_URL,PARAM_USERNAME|});"),
  }),

  -- Returns a particular value for the named variable, taken from POST or GET, otherwise returning a given default. This function should be used to initialise all required values in a script that are based on parameters.
  s('mdl_optional_param', {
    t("optional_param("),
    i(1, "$parameter_name"),
    t(", "),
    i(2, "$default_value"),
    t(", ${3|PARAM_INT,PARAM_TEXT,PARAM_BOOL,PARAM_ALPHA,PARAM_ALPHAEXT,PARAM_ALPHANUM,PARAM_ALPHANUMEXT,PARAM_AUTH,PARAM_BASE64,PARAM_CAPABILITY,PARAM_CLEANHTML,PARAM_EMAIL,PARAM_FILE,PARAM_FLOAT,PARAM_HOST,PARAM_LANG,PARAM_LOCALURL,PARAM_NOTAGS,PARAM_PATH,PARAM_PEM,PARAM_PERMISSION,PARAM_RAW,PARAM_RAW_TRIMMED,PARAM_SAFEDIR,PARAM_SAFEPATH,PARAM_SEQUENCE,PARAM_STRINGID,PARAM_TAG,PARAM_TAGLIST,PARAM_THEME,PARAM_URL,PARAM_USERNAME|});"),
  }),

  -- Returns a particular array for the named variable, taken from POST or GET, otherwise returning a given default. This function should be used to initialise all required values in a script that are based on parameters.
  s('mdl_optional_param_array', {
    t("optional_param_array("),
    i(1, "$parameter_name"),
    t(", "),
    i(2, "$default_value"),
    t(", ${3|PARAM_INT,PARAM_TEXT,PARAM_BOOL,PARAM_ALPHA,PARAM_ALPHAEXT,PARAM_ALPHANUM,PARAM_ALPHANUMEXT,PARAM_AUTH,PARAM_BASE64,PARAM_CAPABILITY,PARAM_CLEANHTML,PARAM_EMAIL,PARAM_FILE,PARAM_FLOAT,PARAM_HOST,PARAM_LANG,PARAM_LOCALURL,PARAM_NOTAGS,PARAM_PATH,PARAM_PEM,PARAM_PERMISSION,PARAM_RAW,PARAM_RAW_TRIMMED,PARAM_SAFEDIR,PARAM_SAFEPATH,PARAM_SEQUENCE,PARAM_STRINGID,PARAM_TAG,PARAM_TAGLIST,PARAM_THEME,PARAM_URL,PARAM_USERNAME|});"),
  }),

  -- Strict validation of parameter values, the values are only converted to requested PHP type. Internally it is using clean_param, the values before and after cleaning must be equal - otherwise an invalid_parameter_exception is thrown.
  s('mdl_validate_param', {
    t("validate_param("),
    i(1, "$param"),
    t(",  ${2|PARAM_INT,PARAM_TEXT,PARAM_BOOL,PARAM_ALPHA,PARAM_ALPHAEXT,PARAM_ALPHANUM,PARAM_ALPHANUMEXT,PARAM_AUTH,PARAM_BASE64,PARAM_CAPABILITY,PARAM_CLEANHTML,PARAM_EMAIL,PARAM_FILE,PARAM_FLOAT,PARAM_HOST,PARAM_LANG,PARAM_LOCALURL,PARAM_NOTAGS,PARAM_PATH,PARAM_PEM,PARAM_PERMISSION,PARAM_RAW,PARAM_RAW_TRIMMED,PARAM_SAFEDIR,PARAM_SAFEPATH,PARAM_SEQUENCE,PARAM_STRINGID,PARAM_TAG,PARAM_TAGLIST,PARAM_THEME,PARAM_URL,PARAM_USERNAME|}"),
    i(2, ", $allownull, $debuginfo"),
    t(");"),
  }),

  -- Makes sure array contains only the allowed types, this function does not validate array key names!
  s('mdl_clean_param_array', {
    t("clean_param_array("),
    i(1, "$param_array"),
    t(",  ${2|PARAM_INT,PARAM_TEXT,PARAM_BOOL,PARAM_ALPHA,PARAM_ALPHAEXT,PARAM_ALPHANUM,PARAM_ALPHANUMEXT,PARAM_AUTH,PARAM_BASE64,PARAM_CAPABILITY,PARAM_CLEANHTML,PARAM_EMAIL,PARAM_FILE,PARAM_FLOAT,PARAM_HOST,PARAM_LANG,PARAM_LOCALURL,PARAM_NOTAGS,PARAM_PATH,PARAM_PEM,PARAM_PERMISSION,PARAM_RAW,PARAM_RAW_TRIMMED,PARAM_SAFEDIR,PARAM_SAFEPATH,PARAM_SEQUENCE,PARAM_STRINGID,PARAM_TAG,PARAM_TAGLIST,PARAM_THEME,PARAM_URL,PARAM_USERNAME|}"),
    i(2, ", $recursive"),
    t(");"),
  }),

  -- Used by {@link optional_param()} and {@link required_param()} to clean the variables and/or cast to specific types, based on an options field.
  s('mdl_clean_param', {
    t("clean_param("),
    i(1, "$param"),
    t(",  ${2|PARAM_INT,PARAM_TEXT,PARAM_BOOL,PARAM_ALPHA,PARAM_ALPHAEXT,PARAM_ALPHANUM,PARAM_ALPHANUMEXT,PARAM_AUTH,PARAM_BASE64,PARAM_CAPABILITY,PARAM_CLEANHTML,PARAM_EMAIL,PARAM_FILE,PARAM_FLOAT,PARAM_HOST,PARAM_LANG,PARAM_LOCALURL,PARAM_NOTAGS,PARAM_PATH,PARAM_PEM,PARAM_PERMISSION,PARAM_RAW,PARAM_RAW_TRIMMED,PARAM_SAFEDIR,PARAM_SAFEPATH,PARAM_SEQUENCE,PARAM_STRINGID,PARAM_TAG,PARAM_TAGLIST,PARAM_THEME,PARAM_URL,PARAM_USERNAME|});"),
  }),

  -- Whether the PARAM_* type is compatible in RTL. Being compatible with RTL means that the data they contain can flow from right-to-left or left-to-right without compromising the user experience.
  s('mdl_is_rtl_compatible', {
    t("is_rtl_compatible(${1|PARAM_INT,PARAM_TEXT,PARAM_BOOL,PARAM_ALPHA,PARAM_ALPHAEXT,PARAM_ALPHANUM,PARAM_ALPHANUMEXT,PARAM_AUTH,PARAM_BASE64,PARAM_CAPABILITY,PARAM_CLEANHTML,PARAM_EMAIL,PARAM_FILE,PARAM_FLOAT,PARAM_HOST,PARAM_LANG,PARAM_LOCALURL,PARAM_NOTAGS,PARAM_PATH,PARAM_PEM,PARAM_PERMISSION,PARAM_RAW,PARAM_RAW_TRIMMED,PARAM_SAFEDIR,PARAM_SAFEPATH,PARAM_SEQUENCE,PARAM_STRINGID,PARAM_TAG,PARAM_TAGLIST,PARAM_THEME,PARAM_URL,PARAM_USERNAME|});"),
  }),

  -- Makes sure the data is using valid utf8, invalid characters are discarded.
  s('mdl_fix_utf8', {
    t("fix_utf8("),
    i(1, "$value"),
    t(");"),
  }),

  -- Return true if given value is integer or string with integer value
  s('mdl_is_number', {
    t("is_number("),
    i(1, "$value"),
    t(");"),
  }),

  -- Returns host part from url.
  s('mdl_get_host_from_url', {
    t("get_host_from_url("),
    i(1, "$url"),
    t(");"),
  }),

  -- Tests whether anything was returned by text editor
  s('mdl_html_is_blank', {
    t("html_is_blank("),
    i(1, "$string"),
    t(");"),
  }),

  -- Set a key in global configuration
  s('mdl_set_config', {
    t("set_config("),
    i(1, "$name"),
    t(", "),
    i(2, "$value"),
    i(3, ", $plugin"),
    t(");"),
  }),

  -- Get configuration values from the global config table or the config_plugins table.
  s('mdl_get_config', {
    t("get_config("),
    i(1, "$plugin"),
    i(2, ", $name"),
    t(");"),
  }),

  -- Removes a key from global configuration.
  s('mdl_unset_config', {
    t("unset_config("),
    i(1, "$name"),
    i(2, ", $plugin"),
    t(");"),
  }),

  -- Remove all the config variables for a given plugin.
  s('mdl_unset_all_config_for_plugin', {
    t("unset_all_config_for_plugin("),
    i(1, "$plugin"),
    t(");"),
  }),

  -- Use this function to get a list of users from a config setting of type admin_setting_users_with_capability.
  s('mdl_get_users_from_config', {
    t("get_users_from_config("),
    i(1, "$value"),
    t(", "),
    i(2, "$capability"),
    i(3, ", $includeadmins"),
    t(");"),
  }),

  -- Invalidates browser caches and cached data in temp.
  s('mdl_purge_all_caches', {
    t("purge_all_caches();"),
  }),

  -- Get volatile flags
  s('mdl_get_cache_flags', {
    t("get_cache_flags("),
    i(1, "$type"),
    i(2, ", $changedsince"),
    t(");"),
  }),

  -- Get volatile flags
  s('mdl_get_cache_flag', {
    t("get_cache_flag("),
    i(1, "$type"),
    t(", "),
    i(2, "$name"),
    i(3, ", $changedsince"),
    t(");"),
  }),

  -- Set a volatile flag
  s('mdl_set_cache_flag', {
    t("set_cache_flag("),
    i(1, "$type"),
    t(", "),
    i(2, "$name"),
    t(", "),
    i(3, "$value"),
    i(4, ", $expiry"),
    t(");"),
  }),

  -- Removes a single volatile flag
  s('mdl_unset_cache_flag', {
    t("unset_cache_flag("),
    i(1, "$type"),
    t(", "),
    i(2, "$name"),
    t(");"),
  }),

  -- Garbage-collect volatile flags
  s('mdl_gc_cache_flags', {
    t("gc_cache_flags();"),
  }),

  -- Refresh user preference cache. This is used most often for $USER object that is stored in session, but it also helps with performance in cron script.
  s('mdl_check_user_preferences_loaded', {
    t("check_user_preferences_loaded("),
    i(1, "$user_stdClass"),
    i(2, ", $cachelifetime"),
    t(");"),
  }),

  -- Called from set/unset_user_preferences, so that the prefs can be correctly reloaded in different sessions.
  s('mdl_mark_user_preferences_changed', {
    t("mark_user_preferences_changed("),
    i(1, "$userid"),
    t(");"),
  }),

  -- Sets a preference for the specified user.
  s('mdl_set_user_preference', {
    t("set_user_preference("),
    i(1, "$name"),
    t(", "),
    i(2, "$value"),
    i(3, ", $user"),
    t(");"),
  }),

  -- Sets a whole array of preferences for the current user
  s('mdl_set_user_preferences', {
    t("set_user_preferences("),
    i(1, "$prefarray_array"),
    i(2, ", $user"),
    t(");"),
  }),

  -- Unsets a preference completely by deleting it from the database
  s('mdl_unset_user_preference', {
    t("unset_user_preference("),
    i(1, "$name"),
    i(2, ", $user"),
    t(");"),
  }),

  -- Used to fetch user preference(s)
  s('mdl_get_user_preferences', {
    t("get_user_preferences("),
    i(1, "{:$name}, $default, $user"),
    t(");"),
  }),

  -- Given Gregorian date parts in user time produce a GMT timestamp.
  s('mdl_make_timestamp', {
    t("make_timestamp("),
    i(1, "$year"),
    i(2, ", $month, $day, $hour, $minute, $second, $timezone, $applydst"),
    t(");"),
  }),

  -- Format a date/time (seconds) as weeks, days, hours etc as needed
  s('mdl_format_time', {
    t("format_time("),
    i(1, "$totalsecs"),
    i(2, ", $str"),
    t(");"),
  }),

  -- Returns a formatted string that represents a date in user time.
  s('mdl_userdate', {
    t("userdate("),
    i(1, "$date"),
    i(2, ", $format, $timezone, $fixday, $fixhour, $fixmonthlang"),
    t(");"),
  }),

  -- Returns a formatted date ensuring it is UTF-8.
  s('mdl_date_format_string', {
    t("date_format_string("),
    i(1, "$date"),
    t(", "),
    i(2, "$format"),
    i(3, ", $timezone"),
    t(");"),
  }),

  -- Given a $time timestamp in GMT (seconds since epoch), returns an array that represents the Gregorian date in user time
  s('mdl_usergetdate', {
    t("usergetdate("),
    i(1, "$time"),
    i(2, ", $timezone"),
    t(");"),
  }),

  -- Given a GMT timestamp (seconds since epoch), offsets it by the timezone. eg 3pm in India is 3pm GMT - 7 * 3600 seconds
  s('mdl_usertime', {
    t("usertime("),
    i(1, "$date"),
    i(2, ", $timezone"),
    t(");"),
  }),

  -- Given a time, return the GMT timestamp of the most recent midnight for the current user.
  s('mdl_usergetmidnight', {
    t("usergetmidnight("),
    i(1, "$date"),
    i(2, ", $timezone"),
    t(");"),
  }),

  -- Returns a string that prints the user's timezone.
  s('mdl_usertimezone', {
    t("usertimezone("),
    i(1, "$timezone"),
    t(");"),
  }),

  -- Returns a float or a string which denotes the user's timezone.
  s('mdl_get_user_timezone', {
    t("get_user_timezone("),
    i(1, "$timezone"),
    t(");"),
  }),

  -- Calculates the Daylight Saving Offset for a given date/time (timestamp). Note: Daylight saving only works for string timezones and not for float.
  s('mdl_dst_offset_on', {
    t("dst_offset_on("),
    i(1, "$time"),
    i(2, ", $strtimezone"),
    t(");"),
  }),

  -- Calculates when the day appears in specific month
  s('mdl_find_day_in_month', {
    t("find_day_in_month("),
    i(1, "$startday"),
    t(", "),
    i(2, "$weekday"),
    t(", "),
    i(3, "$month"),
    t(", "),
    i(4, "$year"),
    t(");"),
  }),

  -- Calculate the number of days in a given month
  s('mdl_days_in_month', {
    t("days_in_month("),
    i(1, "$month"),
    t(", "),
    i(2, "$year"),
    t(");"),
  }),

  -- Calculate the position in the week of a specific calendar day
  s('mdl_dayofweek', {
    t("dayofweek("),
    i(1, "$day"),
    t(", "),
    i(2, "$month"),
    t(", "),
    i(3, "$year"),
    t(");"),
  }),

  -- Returns full login url.
  s('mdl_get_login_url', {
    t("get_login_url();"),
  }),

  -- This function checks that the current user is logged in and has the required privileges
  s('mdl_require_login', {
    t("require_login("),
    i(1, "$courseorid, $autologinguest, $cm, $setwantsurltome, $preventredirect"),
    t(");"),
  }),

  -- This function just makes sure a user is logged out.
  s('mdl_require_logout', {
    t("require_logout();"),
  }),

  -- Weaker version of require_login()
  s('mdl_require_course_login', {
    t("require_course_login("),
    i(1, "$courseorid"),
    i(2, ", $autologinguest, $cm, $setwantsurltome, $preventredirect"),
    t(");"),
  }),

  -- Validates a user key, checking if the key exists, is not expired and the remote ip is correct.
  s('mdl_validate_user_key', {
    t("validate_user_key("),
    i(1, "$keyvalue"),
    t(", "),
    i(2, "$script"),
    t(", "),
    i(3, "$instance"),
    t(");"),
  }),

  -- Require key login. Function terminates with error if key not found or incorrect.
  s('mdl_require_user_key_login', {
    t("require_user_key_login("),
    i(1, "$script"),
    i(2, ", $instance"),
    t(");"),
  }),

  -- Creates a new private user access key.
  s('mdl_create_user_key', {
    t("create_user_key("),
    i(1, "$script"),
    t(", "),
    i(2, "$userid"),
    i(3, ", $instance, $iprestriction, $validuntil"),
    t(");"),
  }),

  -- Delete the user's new private user access keys for a particular script.
  s('mdl_delete_user_key', {
    t("delete_user_key("),
    i(1, "$script"),
    t(", "),
    i(2, "$userid"),
    t(");"),
  }),

  -- Gets a private user access key (and creates one if one doesn't exist).
  s('mdl_get_user_key', {
    t("get_user_key("),
    i(1, "$script"),
    t(", "),
    i(2, "$userid"),
    i(3, ", $instance, $iprestriction, $validuntil"),
    t(");"),
  }),

  -- Modify the user table by setting the currently logged in user's last login to now.
  s('mdl_update_user_login_times', {
    t("update_user_login_times();"),
  }),

  -- Determines if a user has completed setting up their account.
  s('mdl_user_not_fully_set_up', {
    t("user_not_fully_set_up("),
    i(1, "$user"),
    i(2, ", $strict"),
    t(");"),
  }),

  -- Check whether the user has exceeded the bounce threshold
  s('mdl_over_bounce_threshold', {
    t("over_bounce_threshold("),
    i(1, "$user"),
    t(");"),
  }),

  -- Used to increment or reset email sent count
  s('mdl_set_send_count', {
    t("set_send_count("),
    i(1, "$user"),
    i(2, ", $reset"),
    t(");"),
  }),

  -- Increment or reset user's email bounce count
  s('mdl_set_bounce_count', {
    t("set_bounce_count("),
    i(1, "$user"),
    i(2, ", $reset"),
    t(");"),
  }),

  -- Determines if the logged in user is currently moving an activity
  s('mdl_ismoving', {
    t("ismoving("),
    i(1, "$courseid"),
    t(");"),
  }),

  -- Returns a persons full name.
  s('mdl_fullname', {
    t("fullname("),
    i(1, "$user"),
    i(2, ", $override"),
    t(");"),
  }),

  -- A centralised location for the all name fields. Returns an array / sql string snippet.
  s('mdl_get_all_user_name_fields', {
    t("get_all_user_name_fields("),
    i(1, "$returnsql, $tableprefix, $prefix, $fieldprefix, $order"),
    t(");"),
  }),

  -- Reduces lines of duplicated code for getting user name fields.
  s('mdl_username_load_fields_from_object', {
    t("username_load_fields_from_object("),
    i(1, "$addtoobject"),
    t(", "),
    i(2, "$secondobject"),
    i(3, ", $prefix, $additionalfields"),
    t(");"),
  }),

  -- Returns an array of values in order of occurance in a provided string. The key in the result is the character postion in the string.
  s('mdl_order_in_string', {
    t("order_in_string("),
    i(1, "$values"),
    t(", "),
    i(2, "$stringformat"),
    t(");"),
  }),

  -- Checks if current user is shown any extra fields when listing users.
  s('mdl_get_extra_user_fields', {
    t("get_extra_user_fields("),
    i(1, "$context"),
    i(2, ", $already"),
    t(");"),
  }),

  -- If the current user is to be shown extra user fields when listing or selecting users, returns a string suitable for including in an SQL select clause to retrieve those fields.
  s('mdl_get_extra_user_fields_sql', {
    t("get_extra_user_fields_sql("),
    i(1, "$context"),
    i(2, ", $alias, $prefix, $already"),
    t(");"),
  }),

  -- Returns the display name of a field in the user table. Works for most fields that are commonly displayed to users.
  s('mdl_get_user_field_name', {
    t("get_user_field_name("),
    i(1, "$field"),
    t(");"),
  }),

  -- Returns whether a given authentication plugin exists.
  s('mdl_exists_auth_plugin', {
    t("exists_auth_plugin("),
    i(1, "$auth"),
    t(");"),
  }),

  -- Checks if a given plugin is in the list of enabled authentication plugins.
  s('mdl_is_enabled_auth', {
    t("is_enabled_auth("),
    i(1, "$auth"),
    t(");"),
  }),

  -- Returns an authentication plugin instance.
  s('mdl_get_auth_plugin', {
    t("get_auth_plugin("),
    i(1, "$auth"),
    t(");"),
  }),

  -- Returns array of active auth plugins.
  s('mdl_get_enabled_auth_plugins', {
    t("get_enabled_auth_plugins("),
    i(1, "$fix"),
    t(");"),
  }),

  -- Returns true if an internal authentication method is being used. If method not specified then, global default is assumed
  s('mdl_is_internal_auth', {
    t("is_internal_auth("),
    i(1, "$auth"),
    t(");"),
  }),

  -- Returns true if the user is a 'restored' one.
  s('mdl_is_restored_user', {
    t("is_restored_user("),
    i(1, "$username"),
    t(");"),
  }),

  -- Returns an array of user fields
  s('mdl_get_user_fieldnames', {
    t("get_user_fieldnames();"),
  }),

  -- Creates a bare-bones user record
  s('mdl_create_user_record', {
    t("create_user_record("),
    i(1, "$username"),
    t(", "),
    i(2, "$password"),
    i(3, ", $auth"),
    t(");"),
  }),

  -- Will update a local user record from an external source (MNET users can not be updated using this method!).
  s('mdl_update_user_record', {
    t("update_user_record("),
    i(1, "$username"),
    t(");"),
  }),

  -- Will update a local user record from an external source (MNET users can not be updated using this method!).
  s('mdl_update_user_record_by_id', {
    t("update_user_record_by_id("),
    i(1, "$id"),
    t(");"),
  }),

  -- Will truncate userinfo as it comes from auth_get_userinfo (from external auth) which may have large fields.
  s('mdl_truncate_userinfo', {
    t("truncate_userinfo("),
    i(1, "$info_array"),
    t(");"),
  }),

  -- Marks user deleted in internal user database and notifies the auth plugin. Also unenrols user from all roles and does other cleanup.
  s('mdl_delete_user', {
    t("delete_user("),
    i(1, "$user_stdClass"),
    t(");"),
  }),

  -- Retrieve the guest user object.
  s('mdl_guest_user', {
    t("guest_user();"),
  }),

  -- Authenticates a user against the chosen authentication mechanism
  s('mdl_authenticate_user_login', {
    t("authenticate_user_login("),
    i(1, "$username"),
    t(", "),
    i(2, "$password"),
    i(3, ", $ignorelockout, $failurereason, $logintoken"),
    t(");"),
  }),

  -- Call to complete the user login process after authenticate_user_login() has succeeded. It will setup the $USER variable and other required bits and pieces.
  s('mdl_complete_user_login', {
    t("complete_user_login("),
    i(1, "$user"),
    t(");"),
  }),

  -- Check a password hash to see if it was hashed using the legacy hash algorithm (md5).
  s('mdl_password_is_legacy_hash', {
    t("password_is_legacy_hash("),
    i(1, "$password"),
    t(");"),
  }),

  -- Compare password against hash stored in user object to determine if it is valid.
  s('mdl_validate_internal_user_password', {
    t("validate_internal_user_password("),
    i(1, "$user"),
    t(", "),
    i(2, "$password"),
    t(");"),
  }),

  -- Calculate hash for a plain text password.
  s('mdl_hash_internal_user_password', {
    t("hash_internal_user_password("),
    i(1, "$password"),
    i(2, ", $fasthash"),
    t(");"),
  }),

  -- Update password hash in user object (if necessary).
  s('mdl_update_internal_user_password', {
    t("update_internal_user_password("),
    i(1, "$user"),
    t(", "),
    i(2, "$password"),
    i(3, ", $fasthash"),
    t(");"),
  }),

  -- Get a complete user record, which includes all the info in the user record.
  s('mdl_get_complete_user_data', {
    t("get_complete_user_data("),
    i(1, "$field"),
    t(", "),
    i(2, "$value"),
    i(3, ", $mnethostid"),
    t(");"),
  }),

  -- Validate a password against the configured password policy
  s('mdl_check_password_policy', {
    t("check_password_policy("),
    i(1, "$password"),
    t(", "),
    i(2, "$errmsg"),
    t(");"),
  }),

  -- When logging in, this function is run to set certain preferences for the current SESSION.
  s('mdl_set_login_session_preferences', {
    t("set_login_session_preferences();"),
  }),

  -- Delete a course, including all related data from the database, and any associated files.
  s('mdl_delete_course', {
    t("delete_course("),
    i(1, "$courseorid"),
    i(2, ", $showfeedback"),
    t(");"),
  }),

  -- Clear a course out completely, deleting all content but don't delete the course itself.
  s('mdl_remove_course_contents', {
    t("remove_course_contents("),
    i(1, "$courseid"),
    i(2, ", $showfeedback, $options"),
    t(");"),
  }),

  -- Change dates in module - used from course reset.
  s('mdl_shift_course_mod_dates', {
    t("shift_course_mod_dates("),
    i(1, "$modname"),
    t(", "),
    i(2, "$fields"),
    t(", "),
    i(3, "$timeshift"),
    t(", "),
    i(4, "$courseid"),
    i(5, ", $modid"),
    t(");"),
  }),

  -- This function will empty a course of user data. It will retain the activities and the structure of the course.
  s('mdl_reset_course_userdata', {
    t("reset_course_userdata("),
    i(1, "$data"),
    t(");"),
  }),

  -- Generate an email processing address.
  s('mdl_generate_email_processing_address', {
    t("generate_email_processing_address("),
    i(1, "$modid"),
    t(", "),
    i(2, "$modargs"),
    t(");"),
  }),

  -- moodle_process_email
  s('mdl_moodle_process_email', {
    t("moodle_process_email("),
    i(1, "$modargs"),
    t(", "),
    i(2, "$body"),
    t(");"),
  }),

  -- Get mailer instance, enable buffering, flush buffer or disable buffering.
  s('mdl_get_mailer', {
    t("get_mailer("),
    i(1, "$action"),
    t(");"),
  }),

  -- A helper function to test for email diversion
  s('mdl_email_should_be_diverted', {
    t("email_should_be_diverted("),
    i(1, "$email"),
    t(");"),
  }),

  -- Generate a unique email Message-ID using the moodle domain and install path
  s('mdl_generate_email_messageid', {
    t("generate_email_messageid("),
    i(1, "$localpart"),
    t(");"),
  }),

  -- Send an email to a specified user
  s('mdl_email_to_user', {
    t("email_to_user("),
    i(1, "$user"),
    t(", "),
    i(2, "$from"),
    t(", "),
    i(3, "$subject"),
    t(", "),
    i(4, "$messagetext"),
    i(5, ", $messagehtml, $attachment, $attachname, $usetrueaddress${13, $replyto, $replytoname, $wordwrapwidth, $strategy});"),
  }),

  -- Check to see if a user's real email address should be used for the "From" field.
  s('mdl_can_send_from_real_email_address', {
    t("can_send_from_real_email_address("),
    i(1, "$from"),
    t(", "),
    i(2, "$user"),
    i(3, ", $unused"),
    t(");"),
  }),

  -- Generate a signoff for emails based on support settings
  s('mdl_generate_email_signoff', {
    t("generate_email_signoff();"),
  }),

  -- Sets specified user's password and send the new password to the user via email.
  s('mdl_setnew_password_and_mail', {
    t("setnew_password_and_mail("),
    i(1, "$user"),
    i(2, ", $fasthash"),
    t(");"),
  }),

  -- Resets specified user's password and send the new password to the user via email.
  s('mdl_reset_password_and_mail', {
    t("reset_password_and_mail("),
    i(1, "$user"),
    t(");"),
  }),

  -- Send email to specified user with confirmation text and activation link.
  s('mdl_send_confirmation_email', {
    t("send_confirmation_email("),
    i(1, "$user"),
    i(2, ", $confirmationurl"),
    t(");"),
  }),

  -- Sends a password change confirmation email.
  s('mdl_send_password_change_confirmation_email', {
    t("send_password_change_confirmation_email("),
    i(1, "$user"),
    t(", "),
    i(2, "$resetrecord"),
    t(");"),
  }),

  -- Sends an email containinginformation on how to change your password.
  s('mdl_send_password_change_info', {
    t("send_password_change_info("),
    i(1, "$user"),
    t(");"),
  }),

  -- Check that an email is allowed. It returns an error message if there was a problem.
  s('mdl_email_is_not_allowed', {
    t("email_is_not_allowed("),
    i(1, "$email"),
    t(");"),
  }),

  -- Returns local file storage instance
  s('mdl_get_file_storage', {
    t("get_file_storage("),
    i(1, "$reset"),
    t(");"),
  }),

  -- Returns local file storage instance
  s('mdl_get_file_browser', {
    t("get_file_browser();"),
  }),

  -- Returns file packer
  s('mdl_get_file_packer', {
    t("get_file_packer("),
    i(1, "$mimetype"),
    t(");"),
  }),

  -- Returns current name of file on disk if it exists.
  s('mdl_valid_uploaded_file', {
    t("valid_uploaded_file("),
    i(1, "$newfile"),
    t(");"),
  }),

  -- Returns the maximum size for uploading files.
  s('mdl_get_max_upload_file_size', {
    t("get_max_upload_file_size("),
    i(1, "$sitebytes, $coursebytes, $modulebytes, $unused"),
    t(");"),
  }),

  -- Returns the maximum size for uploading files for the current user
  s('mdl_get_user_max_upload_file_size', {
    t("get_user_max_upload_file_size("),
    i(1, "$context"),
    i(2, ", $sitebytes, $coursebytes, $modulebytes, $user, $unused"),
    t(");"),
  }),

  -- Returns an array of possible sizes in local language
  s('mdl_get_max_upload_sizes', {
    t("get_max_upload_sizes("),
    i(1, "$sitebytes, $coursebytes, $modulebytes, $custombytes"),
    t(");"),
  }),

  -- Returns an array with all the filenames in all subdirectories, relative to the given rootdir.
  s('mdl_get_directory_list', {
    t("get_directory_list("),
    i(1, "$rootdir"),
    i(2, ", $excludefiles, $descend, $getdirs, $getfiles"),
    t(");"),
  }),

  -- Adds up all the files in a directory and works out the size.
  s('mdl_get_directory_size', {
    t("get_directory_size("),
    i(1, "$rootdir"),
    i(2, ", $excludefile"),
    t(");"),
  }),

  -- Converts bytes into display form
  s('mdl_display_size', {
    t("display_size("),
    i(1, "$size"),
    t(");"),
  }),

  -- Cleans a given filename by removing suspicious or troublesome characters
  s('mdl_clean_filename', {
    t("clean_filename("),
    i(1, "$string"),
    t(");"),
  }),

  -- Returns the code for the current language
  s('mdl_current_language', {
    t("current_language();"),
  }),

  -- Returns parent language of current active language if defined
  s('mdl_get_parent_language', {
    t("get_parent_language("),
    i(1, "$lang"),
    t(");"),
  }),

  -- Force the current language to get strings and dates localised in the given language.
  s('mdl_force_current_language', {
    t("force_current_language("),
    i(1, "$language"),
    t(");"),
  }),

  -- Returns current string_manager instance.
  s('mdl_get_string_manager', {
    t("get_string_manager("),
    i(1, "$forcereload"),
    t(");"),
  }),

  -- Returns a localized string.
  s('mdl_get_string', {
    t("get_string("),
    i(1, "$identifier"),
    i(2, ", $component, $a, $lazyload"),
    t(");"),
  }),

  -- Converts an array of strings to their localized value.
  s('mdl_get_strings', {
    t("get_strings("),
    i(1, "$array"),
    i(2, ", $component"),
    t(");"),
  }),

  -- Prints out a translated string.
  s('mdl_print_string', {
    t("print_string("),
    i(1, "$identifier"),
    i(2, ", $component, $a"),
    t(");"),
  }),

  -- Returns a list of charset codes
  s('mdl_get_list_of_charsets', {
    t("get_list_of_charsets();"),
  }),

  -- Returns a list of valid and compatible themes
  s('mdl_get_list_of_themes', {
    t("get_list_of_themes();"),
  }),

  -- Factory function for emoticon_manager
  s('mdl_get_emoticon_manager', {
    t("get_emoticon_manager();"),
  }),

  -- rc4encrypt
  s('mdl_rc4encrypt', {
    t("rc4encrypt("),
    i(1, "$data"),
    t(");"),
  }),

  -- rc4decrypt
  s('mdl_rc4decrypt', {
    t("rc4decrypt("),
    i(1, "$data"),
    t(");"),
  }),

  -- Based on a class by Mukul Sabharwal [mukulsabharwal @ yahoo.com]
  s('mdl_endecrypt', {
    t("endecrypt ("),
    i(1, "$pwd"),
    t(", "),
    i(2, "$data"),
    t(", "),
    i(3, "$case"),
    t(");"),
  }),

  -- This method validates a plug name. It is much faster than calling clean_param.
  s('mdl_is_valid_plugin_name', {
    t("is_valid_plugin_name("),
    i(1, "$name"),
    t(");"),
  }),

  -- Get a list of all the plugins of a given type that define a certain API function in a certain file. The plugin component names and function names are returned.
  s('mdl_get_plugin_list_with_function', {
    t("get_plugin_list_with_function("),
    i(1, "$plugintype"),
    t(", "),
    i(2, "$function"),
    i(3, ", $file"),
    t(");"),
  }),

  -- Get a list of all the plugins that define a certain API function in a certain file.
  s('mdl_get_plugins_with_function', {
    t("get_plugins_with_function("),
    i(1, "$function"),
    i(2, ", $file, $include"),
    t(");"),
  }),

  -- Lists plugin-like directories within specified directory
  s('mdl_get_list_of_plugins', {
    t("get_list_of_plugins("),
    i(1, "$directory, $exclude, $basedir"),
    t(");"),
  }),

  -- Invoke plugin's callback functions
  s('mdl_plugin_callback', {
    t("plugin_callback("),
    i(1, "$type"),
    t(", "),
    i(2, "$name"),
    t(", "),
    i(3, "$feature"),
    t(", "),
    i(4, "$action"),
    i(5, ", $params, $default"),
    t(");"),
  }),

  -- Invoke component's callback functions
  s('mdl_component_callback', {
    t("component_callback("),
    i(1, "$component"),
    t(", "),
    i(2, "$function"),
    i(3, ", $params_array, $default"),
    t(");"),
  }),

  -- Determine if a component callback exists and return the function name to call. Note that this function will include the required library files so that the functioname returned can be called directly.
  s('mdl_component_callback_exists', {
    t("component_callback_exists("),
    i(1, "$component"),
    t(", "),
    i(2, "$function"),
    t(");"),
  }),

  -- Call the specified callback method on the provided class.
  s('mdl_component_class_callback', {
    t("component_class_callback("),
    i(1, "$classname"),
    t(", "),
    i(2, "$methodname"),
    t(", "),
    i(3, "$params_array"),
    i(4, ", $default"),
    t(");"),
  }),

  -- Checks whether a plugin supports a specified feature.
  s('mdl_plugin_supports', {
    t("plugin_supports("),
    i(1, "$type"),
    t(", "),
    i(2, "$name"),
    t(", "),
    i(3, "$feature"),
    i(4, ", $default"),
    t(");"),
  }),

  -- Returns true if the current version of PHP is greater that the specified one.
  s('mdl_check_php_version', {
    t("check_php_version("),
    i(1, "$version"),
    t(");"),
  }),

  -- Determine if moodle installation requires update.
  s('mdl_moodle_needs_upgrading', {
    t("moodle_needs_upgrading();"),
  }),

  -- Returns the major version of this site
  s('mdl_moodle_major_version', {
    t("moodle_major_version("),
    i(1, "$fromdisk"),
    t(");"),
  }),

  -- Sets the system locale
  s('mdl_moodle_setlocale', {
    t("moodle_setlocale("),
    i(1, "$locale"),
    t(");"),
  }),

  -- Count words in a string.
  s('mdl_count_words', {
    t("count_words("),
    i(1, "$string"),
    t(");"),
  }),

  -- Count letters in a string.
  s('mdl_count_letters', {
    t("count_letters("),
    i(1, "$string"),
    t(");"),
  }),

  -- Generate and return a random string of the specified length.
  s('mdl_random_string', {
    t("random_string("),
    i(1, "$length"),
    t(");"),
  }),

  -- Generate a complex random string (useful for md5 salts)
  s('mdl_complex_random_string', {
    t("complex_random_string("),
    i(1, "$length"),
    t(");"),
  }),

  -- Try to generates cryptographically secure pseudo-random bytes.
  s('mdl_random_bytes_emulate', {
    t("random_bytes_emulate("),
    i(1, "$length"),
    t(");"),
  }),

  -- Given some text (which may contain HTML) and an ideal length, this function truncates the text neatly on a word boundary if possible
  s('mdl_shorten_text', {
    t("shorten_text("),
    i(1, "$text"),
    i(2, ", $ideal, $exact, $ending"),
    t(");"),
  }),

  -- Shortens a given filename by removing characters positioned after the ideal string length. When the filename is too long, the file cannot be created on the filesystem due to exceeding max byte size. Limiting the filename to a certain size (considering multibyte characters) will prevent this.
  s('mdl_shorten_filename', {
    t("shorten_filename("),
    i(1, "$filename"),
    i(2, ", $length, $includehash"),
    t(");"),
  }),

  -- Shortens a given array of filenames by removing characters positioned after the ideal string length.
  s('mdl_shorten_filenames', {
    t("shorten_filenames("),
    i(1, "$path_array"),
    i(2, ", $length, $includehash"),
    t(");"),
  }),

  -- Given dates in seconds, how many weeks is the date from startdate The first week is 1, the second 2 etc ...
  s('mdl_getweek', {
    t("getweek("),
    i(1, "$startdate"),
    t(", "),
    i(2, "$thedate"),
    t(");"),
  }),

  -- Returns a randomly generated password of length $maxlen. inspired by
  s('mdl_generate_password', {
    t("generate_password("),
    i(1, "$maxlen"),
    t(");"),
  }),

  -- Given a float, prints it nicely.
  s('mdl_format_float', {
    t("format_float("),
    i(1, "$float"),
    i(2, ", $decimalpoints, $localized, $stripzeros"),
    t(");"),
  }),

  -- Converts locale specific floating point/comma number back to standard PHP float value
  s('mdl_unformat_float', {
    t("unformat_float("),
    i(1, "$localefloat"),
    i(2, ", $strict"),
    t(");"),
  }),

  -- Given a simple array, this shuffles it up just like shuffle() Unlike PHP's shuffle() this function works on any machine.
  s('mdl_swapshuffle', {
    t("swapshuffle("),
    i(1, "$array"),
    t(");"),
  }),

  -- swapshuffle_assoc
  s('mdl_swapshuffle_assoc', {
    t("swapshuffle_assoc("),
    i(1, "$array"),
    t(");"),
  }),

  -- Given an arbitrary array, and a number of draws, this function returns an array with that amount of items. The indexes are retained.
  s('mdl_draw_rand_array', {
    t("draw_rand_array("),
    i(1, "$array"),
    t(", "),
    i(2, "$draws"),
    t(");"),
  }),

  -- Calculate the difference between two microtimes
  s('mdl_microtime_diff', {
    t("microtime_diff("),
    i(1, "$a"),
    t(", "),
    i(2, "$b"),
    t(");"),
  }),

  -- Given a list (eg a,b,c,d,e) this function returns an array of 1->a, 2->b, 3->c etc
  s('mdl_make_menu_from_list', {
    t("make_menu_from_list("),
    i(1, "$list"),
    i(2, ", $separator"),
    t(");"),
  }),

  -- Creates an array that represents all the current grades that can be chosen using the given grading type.
  s('mdl_make_grades_menu', {
    t("make_grades_menu("),
    i(1, "$gradingtype"),
    t(");"),
  }),

  -- make_unique_id_code
  s('mdl_make_unique_id_code', {
    t("make_unique_id_code("),
    i(1, "$extra"),
    t(");"),
  }),

  -- Function to check the passed address is within the passed subnet
  s('mdl_address_in_subnet', {
    t("address_in_subnet("),
    i(1, "$addr"),
    t(", "),
    i(2, "$subnetstr"),
    t(");"),
  }),

  -- For outputting debugging info
  s('mdl_mtrace', {
    t("mtrace("),
    i(1, "$string"),
    i(2, ", $eol, $sleep"),
    t(");"),
  }),

  -- Replace 1 or more slashes or backslashes to 1 slash
  s('mdl_cleardoubleslashes', {
    t("cleardoubleslashes ("),
    i(1, "$path"),
    t(");"),
  }),

  -- Is current ip in give list?
  s('mdl_remoteip_in_list', {
    t("remoteip_in_list("),
    i(1, "$list"),
    t(");"),
  }),

  -- Returns most reliable client address
  s('mdl_getremoteaddr', {
    t("getremoteaddr("),
    i(1, "$default"),
    t(");"),
  }),

  -- Cleans an ip address. Internal addresses are now allowed.
  s('mdl_cleanremoteaddr', {
    t("cleanremoteaddr("),
    i(1, "$addr"),
    i(2, ", $compress"),
    t(");"),
  }),

  -- Is IP address a public address?
  s('mdl_ip_is_public', {
    t("ip_is_public("),
    i(1, "$ip"),
    t(");"),
  }),

  -- This function will make a complete copy of anything it's given, regardless of whether it's an object or not.
  s('mdl_fullclone', {
    t("fullclone("),
    i(1, "$thing"),
    t(");"),
  }),

  -- Used to make sure that $min <= $value <= $max
  s('mdl_bounded_number', {
    t("bounded_number("),
    i(1, "$min"),
    t(", "),
    i(2, "$value"),
    t(", "),
    i(3, "$max"),
    t(");"),
  }),

  -- Check if there is a nested array within the passed array
  s('mdl_array_is_nested', {
    t("array_is_nested("),
    i(1, "$array"),
    t(");"),
  }),

  -- get_performance_info() pairs up with init_performance_info() loaded in setup.php. Returns an array with 'html' and 'txt' values ready for use, and each of the individual stats provided separately as well.
  s('mdl_get_performance_info', {
    t("get_performance_info();"),
  }),

  -- Delete directory or only its content
  s('mdl_remove_dir', {
    t("remove_dir("),
    i(1, "$dir"),
    i(2, ", $contentonly"),
    t(");"),
  }),

  -- Detect if an object or a class contains a given property will take an actual object or the name of a class
  s('mdl_object_property_exists', {
    t("object_property_exists("),
    i(1, "$obj"),
    t(", "),
    i(2, "$property"),
    t(");"),
  }),

  -- Converts an object into an associative array
  s('mdl_convert_to_array', {
    t("convert_to_array("),
    i(1, "$var"),
    t(");"),
  }),

  -- Detect a custom script replacement in the data directory that will replace an existing moodle script
  s('mdl_custom_script_path', {
    t("custom_script_path();"),
  }),

  -- Returns whether or not the user object is a remote MNET user. This function is in moodlelib because it does not rely on loading any of the MNET code.
  s('mdl_is_mnet_remote_user', {
    t("is_mnet_remote_user("),
    i(1, "$user"),
    t(");"),
  }),

  -- This function will search for browser prefereed languages, setting Moodle to use the best one available if $SESSION->lang is undefined
  s('mdl_setup_lang_from_browser', {
    t("setup_lang_from_browser();"),
  }),

  -- Check if $url matches anything in proxybypass list
  s('mdl_is_proxybypass', {
    t("is_proxybypass("),
    i(1, "$url"),
    t(");"),
  }),

  -- Check if the passed navigation is of the new style
  s('mdl_is_newnav', {
    t("is_newnav("),
    i(1, "$navigation"),
    t(");"),
  }),

  -- Checks whether the given variable name is defined as a variable within the given object.
  s('mdl_in_object_vars', {
    t("in_object_vars("),
    i(1, "$var"),
    t(", "),
    i(2, "$object"),
    t(");"),
  }),

  -- Returns an array without repeated objects.
  s('mdl_object_array_unique', {
    t("object_array_unique("),
    i(1, "$array"),
    i(2, ", $keepkeyassoc"),
    t(");"),
  }),

  -- Is a userid the primary administrator?
  s('mdl_is_primary_admin', {
    t("is_primary_admin("),
    i(1, "$userid"),
    t(");"),
  }),

  -- Returns the site identifier
  s('mdl_get_site_identifier', {
    t("get_site_identifier();"),
  }),

  -- Check whether the given password has no more than the specified number of consecutive identical characters.
  s('mdl_check_consecutive_identical_characters', {
    t("check_consecutive_identical_characters("),
    i(1, "$password"),
    t(", "),
    i(2, "$maxchars"),
    t(");"),
  }),

  -- Helper function to do partial function binding. so we can use it for preg_replace_callback, for example this works with php functions, user functions, static methods and class methods it returns you a callback that you can pass on like so:
  s('mdl_partial', {
    t("partial();"),
  }),

  -- helper function to load up and initialise the mnet environment this must be called before you use mnet functions.
  s('mdl_get_mnet_environment', {
    t("get_mnet_environment();"),
  }),

  -- during xmlrpc server code execution, any code wishing to access information about the remote peer must use this to get it.
  s('mdl_get_mnet_remote_client', {
    t("get_mnet_remote_client();"),
  }),

  -- during the xmlrpc server code execution, this will be called to setup the object returned by {@link get_mnet_remote_client}
  s('mdl_set_mnet_remote_client', {
    t("set_mnet_remote_client("),
    i(1, "$client"),
    t(");"),
  }),

  -- return the jump url for a given remote user this is used for rewriting forum post links in emails, etc
  s('mdl_mnet_get_idp_jump_url', {
    t("mnet_get_idp_jump_url("),
    i(1, "$user"),
    t(");"),
  }),

  -- Gets the homepage to use for the current user
  s('mdl_get_home_page', {
    t("get_home_page();"),
  }),

  -- ets the name of a course to be displayed when showing a list of courses. By default this is just $course->fullname but user can configure it. The result of this function should be passed through print_string.
  s('mdl_get_course_display_name_for_list', {
    t("get_course_display_name_for_list("),
    i(1, "$course"),
    t(");"),
  }),

  -- Safe analogue of unserialize() that can only parse arrays
  s('mdl_unserialize_array', {
    t("unserialize_array("),
    i(1, "$expression"),
    t(");"),
  }),

  -- Get human readable name describing the given callable.
  s('mdl_get_callable_name', {
    t("get_callable_name("),
    i(1, "$callable"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_get_context_instance', {
    t("get_context_instance("),
    i(1, "$contextlevel"),
    t(", "),
    i(2, "$instance = 0"),
    t(", "),
    i(3, "$strictness = IGNORE_MISSING"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_get_context_instance_by_id', {
    t("get_context_instance_by_id("),
    i(1, "$id"),
    t(", "),
    i(2, "$strictness = IGNORE_MISSING"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_has_capability', {
    t("has_capability("),
    i(1, "$capability"),
    t(", "),
    i(2, "context $context"),
    t(", "),
    i(3, "$user = null"),
    t(", "),
    i(4, "$doanything = true"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_require_capability', {
    t("require_capability("),
    i(1, "$capability"),
    t(", "),
    i(2, "context $context"),
    t(", "),
    i(3, "$userid = null"),
    t(", "),
    i(4, "$doanything = true"),
    t(", "),
    i(5, "$errormessage = 'nopermissions'"),
    t(", "),
    i(6, "$stringfile = ''"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_get_users_by_capability', {
    t("get_users_by_capability("),
    i(1, "context $context"),
    t(", "),
    i(2, "$capability"),
    t(", "),
    i(3, "$fields = ''"),
    t(", "),
    i(4, "$sort = ''"),
    t(", "),
    i(5, "$limitfrom = ''"),
    t(", "),
    i(6, "$limitnum = ''"),
    t(", "),
    i(7, "$groups = ''"),
    t(", "),
    i(8, "$exceptions = ''"),
    t(", "),
    i(9, "$doanything_ignored = null"),
    t(", "),
    i(10, "$view_ignored = null"),
    t(", "),
    i(11, "$useviewallgroups = false"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_isguestuser', {
    t("isguestuser("),
    i(1, "$user = null"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_isloggedin', {
    t("isloggedin();"),
  }),

  -- Moodle snippets
  s('mdl_is_siteadmin', {
    t("is_siteadmin("),
    i(1, "$user_or_id = null"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_is_guest', {
    t("is_guest("),
    i(1, "context $context"),
    t(", "),
    i(2, "$user = null"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_is_viewing', {
    t("is_viewing("),
    i(1, "context $context"),
    t(", "),
    i(2, " $user = null"),
    t(", "),
    i(3, " $withcapability = ''"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_allow_commit', {
    t("allow_commit();"),
  }),

  -- Moodle snippets
  s('mdl_get_course', {
    t("get_course("),
    i(1, "$courseid"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_get_file_content', {
    t("get_file_content("),
    i(1, "'userfile'"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_get_new_filename', {
    t("get_new_filename("),
    i(1, "'userfile'"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_save_file', {
    t("save_file("),
    i(1, "'userfile'"),
    t(", "),
    i(2, " $fullpath"),
    t(", "),
    i(3, " $override"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_save_stored_file', {
    t("save_stored_file("),
    i(1, "'userfile'"),
    t(", "),
    i(2, " ..."),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_file_get_submitted_draft_itemid', {
    t("file_get_submitted_draft_itemid("),
    i(1, "'entry'"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_file_prepare_draft_area', {
    t("file_prepare_draft_area("),
    i(1, "$draftid_editor"),
    t(", "),
    i(2, " $context->id"),
    t(", "),
    i(3, " 'mod_MYMOD'"),
    t(", "),
    i(4, " 'entry'"),
    t(", "),
    i(5, " $entry->id"),
    t(", "),
    i(6, " array('subdirs'=>true)"),
    t(", "),
    i(7, " $entry->definition"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_file_save_draft_area_files', {
    t("file_save_draft_area_files("),
    i(1, "$data->attachments"),
    t(", "),
    i(2, " $context->id"),
    t(", "),
    i(3, " 'mod_glossary'"),
    t(", "),
    i(4, " 'attachment'"),
    t(", "),
    i(5, " $entry->id"),
    t(", array("),
    i(6, "'subdirs' => 0"),
    t(", "),
    i(7, " 'maxbytes' => $maxbytes"),
    t(", "),
    i(8, " 'maxfiles' => 50"),
    t("));"),
  }),

  -- Moodle snippets
  s('mdl_file_rewrite_pluginfile_urls', {
    t("file_rewrite_pluginfile_urls("),
    i(1, "$messagetext"),
    t(", "),
    i(2, " 'pluginfile.php'"),
    t(", "),
    i(3, " $context->id"),
    t(", "),
    i(4, " 'mod_mymodule'"),
    t(", "),
    i(5, " 'proper_file_area'"),
    t(", "),
    i(6, " $itemid"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_file_prepare_standard_editor', {
    t("file_prepare_standard_editor("),
    i(1, "$data"),
    t(", "),
    i(2, " 'textfield'"),
    t(", "),
    i(3, " $textfieldoptions"),
    t(", "),
    i(4, " $context"),
    t(", "),
    i(5, " 'mod_somemodule'"),
    t(", "),
    i(6, " 'somearea'"),
    t(", "),
    i(7, " $data->id"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_file_prepare_standard_filemanager', {
    t("file_prepare_standard_filemanager("),
    i(1, "$entry"),
    t(", "),
    i(2, " 'attachment'"),
    t(", "),
    i(3, " $attachmentoptions"),
    t(", "),
    i(4, " $context"),
    t(", "),
    i(5, " 'mod_mymod'"),
    t(", "),
    i(6, " 'attachment'"),
    t(", "),
    i(7, " $entry->id"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_file_postupdate_standard_filemanager', {
    t("file_postupdate_standard_filemanager("),
    i(1, "$entry"),
    t(", "),
    i(2, " 'attachment'"),
    t(", "),
    i(3, " $attachmentoptions"),
    t(", "),
    i(4, " $context"),
    t(", "),
    i(5, " 'mod_mymod'"),
    t(", "),
    i(6, " 'attachment'"),
    t(", "),
    i(7, " $entry->id"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_file_postupdate_standard_editor', {
    t("file_postupdate_standard_editor("),
    i(1, "$data"),
    t(", "),
    i(2, " 'textfield'"),
    t(", "),
    i(3, " $textfieldoptions"),
    t(", "),
    i(4, " $context"),
    t(", "),
    i(5, " 'mod_somemodule'"),
    t(", "),
    i(6, " 'somearea'"),
    t(", "),
    i(7, " $data->id"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_make_pluginfile_url', {
    t("make_pluginfile_url("),
    i(1, "$file->get_contextid()"),
    t(", "),
    i(2, " $file->get_component()"),
    t(", "),
    i(3, " $file->get_filearea()"),
    t(", "),
    i(4, " $file->get_itemid()"),
    t(", "),
    i(5, " $file->get_filepath()"),
    t(", "),
    i(6, " $file->get_filename()"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_myplugin_pluginfile', {
    t("myPLUGIN_pluginfile("),
    i(1, "$course"),
    t(", "),
    i(2, " $cm"),
    t(", "),
    i(3, " $context"),
    t(", "),
    i(4, " $filearea"),
    t(", "),
    i(5, " $args"),
    t(", "),
    i(6, " $forcedownload"),
    t(", "),
    i(7, " array $options=array()"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_get_file', {
    t("get_file("),
    i(1, "$context->id"),
    t(", "),
    i(2, " 'mod_MYPLUGIN'"),
    t(", "),
    i(3, " $filearea"),
    t(", "),
    i(4, " $itemid"),
    t(", "),
    i(5, " $filepath"),
    t(", "),
    i(6, " $filename"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_send_file', {
    t("send_file("),
    i(1, "$file"),
    t(", "),
    i(2, " 86400"),
    t(", "),
    i(3, " 0"),
    t(", "),
    i(4, " $forcedownload"),
    t(", "),
    i(5, " $options"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_get_system_context', {
    t("get_system_context();"),
  }),

  -- Moodle snippets
  s('mdl_get_file_info', {
    t("get_file_info("),
    i(1, "$context"),
    t(", "),
    i(2, " $component"),
    t(", "),
    i(3, " $filearea"),
    t(", "),
    i(4, " $itemid"),
    t(", "),
    i(5, " '/'"),
    t(", "),
    i(6, " $filename"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_get_parent', {
    t("get_parent();"),
  }),

  -- Moodle snippets
  s('mdl_get_children', {
    t("get_children();"),
  }),

  -- Moodle snippets
  s('mdl_is_directory', {
    t("is_directory();"),
  }),

  -- Moodle snippets
  s('mdl_get_visible_name', {
    t("get_visible_name();"),
  }),

  -- Moodle snippets
  s('mdl_get_params', {
    t("get_params();"),
  }),

  -- Moodle snippets
  s('mdl_create_file_from_pathname', {
    t("create_file_from_pathname("),
    i(1, "$file_record"),
    t(", "),
    i(2, " $from_zip_file"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_get_area_files', {
    t("get_area_files("),
    i(1, "$contextid"),
    t(", "),
    i(2, " 'mod_MYMOD'"),
    t(", "),
    i(3, " 'AREA'"),
    t(", "),
    i(4, " $submission->id"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_get_filename', {
    t("get_filename();"),
  }),

  -- Moodle snippets
  s('mdl_get_itemid', {
    t("get_itemid();"),
  }),

  -- Moodle snippets
  s('mdl_get_filepath', {
    t("get_filepath();"),
  }),

  -- Moodle snippets
  s('mdl_get_component', {
    t("get_component();"),
  }),

  -- Moodle snippets
  s('mdl_get_contextid', {
    t("get_contextid();"),
  }),

  -- Moodle snippets
  s('mdl_get_filearea', {
    t("get_filearea();"),
  }),

  -- Moodle snippets
  s('mdl_create_file_from_string', {
    t("create_file_from_string("),
    i(1, "$fileinfo"),
    t(", "),
    i(2, " 'hello world'"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_get_content', {
    t("get_content();"),
  }),

  -- Moodle snippets
  s('mdl_delete', {
    t("delete();"),
  }),

  -- Moodle snippets
  s('mdl_addgrouprule', {
    t("addGroupRule("),
    i(1, "'elementname'"),
    t(", array("),
    i(2, "'value'"),
    t(" => array(array("),
    i(3, "list"),
    t(", "),
    i(4, " of"),
    t(", "),
    i(5, " rule"),
    t(", "),
    i(6, " params"),
    t(", "),
    i(7, " but"),
    t(", "),
    i(8, " fieldname"),
    t("))));"),
  }),

  -- Moodle snippets
  s('mdl_createelement', {
    t("createElement("),
    i(1, "'radio'"),
    t(", "),
    i(2, " 'yesno'"),
    t(", "),
    i(3, " ''"),
    t(", "),
    i(4, " get_string('yes')"),
    t(", "),
    i(5, " 1"),
    t(", "),
    i(6, " $attributes"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_setdefault', {
    t("setDefault("),
    i(1, "'yesno'"),
    t(", "),
    i(2, " 0"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_setmultiple', {
    t("setMultiple("),
    i(1, "true"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_addgroup', {
    t("addGroup("),
    i(1, "$buttonarray"),
    t(", "),
    i(2, " 'buttonar'"),
    t(", "),
    i(3, " ''"),
    t(", "),
    i(4, " array(' ')"),
    t(", "),
    i(5, " false"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_disabledif', {
    t("disabledIf("),
    i(1, "'mycontrol'"),
    t(", "),
    i(2, " 'someselect'"),
    t(", "),
    i(3, " 'neq'"),
    t(", "),
    i(4, " 42"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_addrule', {
    t("addRule("),
    i(1, "'elementname'"),
    t(", "),
    i(2, " get_string('error')"),
    t(", "),
    i(3, " 'rule type'"),
    t(", "),
    i(4, " 'extraruledata'"),
    t(", "),
    i(5, " 'server'(default)"),
    t(", "),
    i(6, " false"),
    t(", "),
    i(7, " false"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_sethelpbutton', {
    t("setHelpButton("),
    i(1, "'lessondefault'"),
    t(", array("),
    i(2, "'lessondefault'"),
    t(", "),
    i(3, " get_string('lessondefault', 'lesson')"),
    t(", "),
    i(4, " 'lesson')"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_addhelpbutton', {
    t("addHelpButton("),
    i(1, "'api_key_field'"),
    t(", "),
    i(2, " 'api_key'"),
    t(", "),
    i(3, " 'block_extsearch'"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_disable_form_change_checker', {
    t("disable_form_change_checker();"),
  }),

  -- Moodle snippets
  s('mdl_settype', {
    t("setType("),
    i(1, "'name'"),
    t(", "),
    i(2, "PARAM_TYPE"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_add_to_log', {
    t("add_to_log("),
    i(1, "$courseid"),
    t(", "),
    i(2, " $module"),
    t(", "),
    i(3, " $action"),
    t(", "),
    i(4, " $url=''"),
    t(", "),
    i(5, " $info=''"),
    t(", "),
    i(6, " $cm=0"),
    t(", "),
    i(7, " $user=0"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_user_accesstime_log', {
    t("user_accesstime_log("),
    i(1, "$courseid=0"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_get_logs', {
    t("get_logs("),
    i(1, "$select"),
    t(", "),
    i(2, " array $params=null"),
    t(", "),
    i(3, " $order='l.time DESC'"),
    t(", "),
    i(4, " $limitfrom=''"),
    t(", "),
    i(5, " $limitnum=''"),
    t(", "),
    i(6, " &$totalcount"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_get_logs_usercourse', {
    t("get_logs_usercourse("),
    i(1, "$userid"),
    t(", "),
    i(2, " $courseid"),
    t(", "),
    i(3, " $coursestart"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_get_logs_userday', {
    t("get_logs_userday("),
    i(1, "$userid"),
    t(", "),
    i(2, " $courseid"),
    t(", "),
    i(3, " $daystart"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_make_active', {
    t("make_active();"),
  }),

  -- Moodle snippets
  s('mdl_get_coursemodule_from_id', {
    t("get_coursemodule_from_id("),
    i(1, "'mymodulename'"),
    t(", "),
    i(2, " $cmid"),
    t(", "),
    i(3, " 0"),
    t(", "),
    i(4, " false"),
    t(", "),
    i(5, " MUST_EXIST"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_get_strings_2', {
    t("get_strings(array("),
    i(1, "'enable'"),
    t(", "),
    i(2, " 'disable'"),
    t(", "),
    i(3, " 'up'"),
    t(", "),
    i(4, " 'down'"),
    t(", "),
    i(5, " 'none')"),
    t(", "),
    i(6, " 'qtype_dragdrop'"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_asort', {
    t("asort();"),
  }),

  -- Moodle snippets
  s('mdl_code2utf8', {
    t("code2utf8("),
    i(1, "$string"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_convert', {
    t("convert("),
    i(1, "$string"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_encode_mimeheader', {
    t("encode_mimeheader("),
    i(1, "$string"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_entities_to_utf8', {
    t("entities_to_utf8("),
    i(1, "$string"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_specialtoascii', {
    t("specialtoascii("),
    i(1, "$string"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_strlen', {
    t("strlen("),
    i(1, "$string"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_strpos', {
    t("strpos("),
    i(1, "$string"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_strrpos', {
    t("strrpos("),
    i(1, "$string"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_strtolower', {
    t("strtolower("),
    i(1, "$string"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_strtotitle', {
    t("strtotitle("),
    i(1, "$string"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_strtoupper', {
    t("strtoupper("),
    i(1, "$string"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_substr', {
    t("substr("),
    i(1, "$string"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_trim_utf8_bom', {
    t("trim_utf8_bom("),
    i(1, "$string"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_utf8_to_entities', {
    t("utf8_to_entities("),
    i(1, "$string"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_add', {
    t("add(new admin_setting_FIELDTYPE("),
    i(1, "'MYMOD/MYNAME'"),
    t(", "),
    i(2, " 'MYNAME'"),
    t(", "),
    i(3, " 'MYDESC'"),
    t(", array("),
    i(4, "'value' => '0'"),
    t(", "),
    i(5, " 'fix' => false)"),
    t(", "),
    i(6, " PARAM_INT"),
    t("));"),
  }),

  -- Moodle snippets
  s('mdl_get_fast_modinfo', {
    t("get_fast_modinfo("),
    i(1, "$course"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_filter_user_list', {
    t("filter_user_list("),
    i(1, "$users"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_define_my_steps', {
    t("define_my_steps();"),
  }),

  -- Moodle snippets
  s('mdl_set_source_table', {
    t("set_source_table();"),
  }),

  -- Moodle snippets
  s('mdl_set_source_sql', {
    t("set_source_sql();"),
  }),

  -- Moodle snippets
  s('mdl_prepare_activity_structure', {
    t("prepare_activity_structure();"),
  }),

  -- Moodle snippets
  s('mdl_calendar_event_hook', {
    t("calendar_event_hook("),
    i(1, "$action"),
    t(", "),
    i(2, " array $args"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_get_default_courses', {
    t("calendar_get_default_courses();"),
  }),

  -- Moodle snippets
  s('mdl_calendar_get_days', {
    t("calendar_get_days();"),
  }),

  -- Moodle snippets
  s('mdl_calendar_get_starting_weekday', {
    t("calendar_get_starting_weekday();"),
  }),

  -- Moodle snippets
  s('mdl_calendar_day_representation', {
    t("calendar_day_representation("),
    i(1, "$tstamp"),
    t(", "),
    i(2, " $now = false"),
    t(", "),
    i(3, " $usecommonwords = true"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_time_representation', {
    t("calendar_time_representation("),
    i(1, "$time"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_wday_name', {
    t("calendar_wday_name("),
    i(1, "$englishname"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_days_in_month', {
    t("calendar_days_in_month("),
    i(1, "$month"),
    t(", "),
    i(2, " $year"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_get_link_href', {
    t("calendar_get_link_href("),
    i(1, "$linkbase"),
    t(", "),
    i(2, " $d"),
    t(", "),
    i(3, " $m"),
    t(", "),
    i(4, " $y"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_get_mini', {
    t("calendar_get_mini("),
    i(1, "$courses"),
    t(", "),
    i(2, " $groups"),
    t(", "),
    i(3, " $users"),
    t(", "),
    i(4, " $cal_month = false"),
    t(", "),
    i(5, " $cal_year = false"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_get_popup', {
    t("calendar_get_popup("),
    i(1, "$is_today"),
    t(", "),
    i(2, " $event_timestart"),
    t(", "),
    i(3, " $popupcontent = ''"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_add_month', {
    t("calendar_add_month("),
    i(1, "$month"),
    t(", "),
    i(2, " $year"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_sub_month', {
    t("calendar_sub_month("),
    i(1, "$month"),
    t(", "),
    i(2, " $year"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_get_module_cached', {
    t("calendar_get_module_cached("),
    i(1, "&$coursecache"),
    t(", "),
    i(2, " $modulename"),
    t(", "),
    i(3, " $instance"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_get_course_cached', {
    t("calendar_get_course_cached("),
    i(1, "&$coursecache"),
    t(", "),
    i(2, " $courseid"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_print_month_selector', {
    t("calendar_print_month_selector("),
    i(1, "$name"),
    t(", "),
    i(2, " $selected"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_top_controls', {
    t("calendar_top_controls("),
    i(1, "$type"),
    t(", "),
    i(2, " $data"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_filter_controls', {
    t("calendar_filter_controls("),
    i(1, "moodle_url $returnurl"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_preferences_button', {
    t("calendar_preferences_button("),
    i(1, "stdClass $course"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_set_filters', {
    t("calendar_set_filters("),
    i(1, "array $courseeventsfrom"),
    t(", "),
    i(2, " $ignorefilters = false"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_get_link_previous', {
    t("calendar_get_link_previous("),
    i(1, "$text"),
    t(", "),
    i(2, " $linkbase"),
    t(", "),
    i(3, " $d"),
    t(", "),
    i(4, " $m"),
    t(", "),
    i(5, " $y"),
    t(", "),
    i(6, " $accesshide = false"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_get_link_next', {
    t("calendar_get_link_next("),
    i(1, "$text"),
    t(", "),
    i(2, " $linkbase"),
    t(", "),
    i(3, " $d"),
    t(", "),
    i(4, " $m"),
    t(", "),
    i(5, " $y"),
    t(", "),
    i(6, " $accesshide = false"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_get_allowed_types', {
    t("calendar_get_allowed_types("),
    i(1, "&$allowed"),
    t(", "),
    i(2, " $course = null"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_add_event_allowed', {
    t("calendar_add_event_allowed("),
    i(1, "$event"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_edit_event_allowed', {
    t("calendar_edit_event_allowed("),
    i(1, "$event"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_user_can_add_event', {
    t("calendar_user_can_add_event("),
    i(1, "$course"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_show_event_type', {
    t("calendar_show_event_type("),
    i(1, "$type"),
    t(", "),
    i(2, " $user = null"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_set_event_type_display', {
    t("calendar_set_event_type_display("),
    i(1, "$type"),
    t(", "),
    i(2, " $display = null"),
    t(", "),
    i(3, " $user = null"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_get_events', {
    t("calendar_get_events("),
    i(1, "$tstart"),
    t(", "),
    i(2, " $tend"),
    t(", "),
    i(3, " $users"),
    t(", "),
    i(4, " $groups"),
    t(", "),
    i(5, " $courses"),
    t(", "),
    i(6, " $withduration = true"),
    t(", "),
    i(7, " $ignorehidden = true"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_events_by_day', {
    t("calendar_events_by_day("),
    i(1, "$events"),
    t(", "),
    i(2, " $month"),
    t(", "),
    i(3, " $year"),
    t(", "),
    i(4, " &$eventsbyday"),
    t(", "),
    i(5, " &$durationbyday"),
    t(", "),
    i(6, " &$typesbyday"),
    t(", "),
    i(7, " &$courses"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_get_upcoming', {
    t("calendar_get_upcoming("),
    i(1, "$courses"),
    t(", "),
    i(2, " $groups"),
    t(", "),
    i(3, " $users"),
    t(", "),
    i(4, " $daysinfuture"),
    t(", "),
    i(5, " $maxevents"),
    t(", "),
    i(6, " $fromtime = 0"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_get_block_upcoming', {
    t("calendar_get_block_upcoming("),
    i(1, "$events"),
    t(", "),
    i(2, " $linkhref = NULL"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_format_event_time', {
    t("calendar_format_event_time("),
    i(1, "$event"),
    t(", "),
    i(2, " $now"),
    t(", "),
    i(3, " $linkparams = null"),
    t(", "),
    i(4, " $usecommonwords = true"),
    t(", "),
    i(5, " $showtime = 0"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_add_event_metadata', {
    t("calendar_add_event_metadata("),
    i(1, "$event"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_table_exists', {
    t("table_exists("),
    i(1, "$table"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_create_table', {
    t("create_table("),
    i(1, "$table"),
    t(", "),
    i(2, " $continue=true"),
    t(", "),
    i(3, " $feedback=true"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_drop_table', {
    t("drop_table("),
    i(1, "$table"),
    t(", "),
    i(2, " $continue=true"),
    t(", "),
    i(3, " $feedback=true"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_rename_table', {
    t("rename_table("),
    i(1, "$table"),
    t(", "),
    i(2, " $newname"),
    t(", "),
    i(3, " $continue=true"),
    t(", "),
    i(4, " $feedback=true"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_field_exists', {
    t("field_exists("),
    i(1, "$table"),
    t(", "),
    i(2, " $field"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_add_field', {
    t("add_field("),
    i(1, "$table"),
    t(", "),
    i(2, " $field"),
    t(", "),
    i(3, " $continue=true"),
    t(", "),
    i(4, " $feedback=true"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_drop_field', {
    t("drop_field("),
    i(1, "$table"),
    t(", "),
    i(2, " $field"),
    t(", "),
    i(3, " $continue=true"),
    t(", "),
    i(4, " $feedback=true"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_change_field_type', {
    t("change_field_type("),
    i(1, "$table"),
    t(", "),
    i(2, " $field"),
    t(", "),
    i(3, " $continue=true"),
    t(", "),
    i(4, " $feedback=true"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_change_field_precision', {
    t("change_field_precision("),
    i(1, "$table"),
    t(", "),
    i(2, " $field"),
    t(", "),
    i(3, " $continue=true"),
    t(", "),
    i(4, " $feedback=true"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_change_field_unsigned', {
    t("change_field_unsigned("),
    i(1, "$table"),
    t(", "),
    i(2, " $field"),
    t(", "),
    i(3, " $continue=true"),
    t(", "),
    i(4, " $feedback=true"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_change_field_notnull', {
    t("change_field_notnull("),
    i(1, "$table"),
    t(", "),
    i(2, " $field"),
    t(", "),
    i(3, " $continue=true"),
    t(", "),
    i(4, " $feedback=true"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_drop_enum_from_field', {
    t("drop_enum_from_field("),
    i(1, "$table"),
    t(", "),
    i(2, " $field"),
    t(", "),
    i(3, " $continue=true"),
    t(", "),
    i(4, " $feedback=true"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_change_field_default', {
    t("change_field_default("),
    i(1, "$table"),
    t(", "),
    i(2, " $field"),
    t(", "),
    i(3, " $continue=true"),
    t(", "),
    i(4, " $feedback=true"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_rename_field', {
    t("rename_field("),
    i(1, "$table"),
    t(", "),
    i(2, " $field"),
    t(", "),
    i(3, " $newname"),
    t(", "),
    i(4, " $continue=true"),
    t(", "),
    i(5, " $feedback=true"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_index_exists', {
    t("index_exists("),
    i(1, "$table"),
    t(", "),
    i(2, " $index"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_find_index_name', {
    t("find_index_name("),
    i(1, "$table"),
    t(", "),
    i(2, " $index"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_add_index', {
    t("add_index("),
    i(1, "$table"),
    t(", "),
    i(2, " $index"),
    t(", "),
    i(3, " $continue=true"),
    t(", "),
    i(4, " $feedback=true"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_drop_index', {
    t("drop_index("),
    i(1, "$table"),
    t(", "),
    i(2, " $index"),
    t(", "),
    i(3, " $continue=true"),
    t(", "),
    i(4, " $feedback=true"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_is_enrolled', {
    t("is_enrolled("),
    i(1, "context $context"),
    t(", "),
    i(2, " $user = null"),
    t(", "),
    i(3, " $withcapability = ''"),
    t(", "),
    i(4, " $onlyactive = false"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_get_enrolled_sql', {
    t("get_enrolled_sql("),
    i(1, "context $context"),
    t(", "),
    i(2, " $withcapability = ''"),
    t(", "),
    i(3, " $groupid = 0"),
    t(", "),
    i(4, " $onlyactive = false"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_get_enrolled_users', {
    t("get_enrolled_users("),
    i(1, "context $context"),
    t(", "),
    i(2, " $withcapability = ''"),
    t(", "),
    i(3, " $groupid = 0"),
    t(", "),
    i(4, " $userfields = 'u.*'"),
    t(", "),
    i(5, " $orderby = ''"),
    t(", "),
    i(6, " $limitfrom = 0"),
    t(", "),
    i(7, " $limitnum = 0"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_count_enrolled_users', {
    t("count_enrolled_users("),
    i(1, "context $context"),
    t(", "),
    i(2, " $withcapability = ''"),
    t(", "),
    i(3, " $groupid = 0"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_events_trigger', {
    t("events_trigger("),
    i(1, "'user_enrolled'"),
    t(", "),
    i(2, " $ue"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_message_send', {
    t("message_send("),
    i(1, "$eventdata"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_get_ratings', {
    t("get_ratings();"),
  }),

  -- Moodle snippets
  s('mdl_get_user_grades', {
    t("get_user_grades();"),
  }),

  -- Moodle snippets
  s('mdl_delete_ratings', {
    t("delete_ratings();"),
  }),

  -- Moodle snippets
  s('mdl_tag_set', {
    t("tag_set("),
    i(1, "'user'"),
    t(", "),
    i(2, " $userId"),
    t(", "),
    i(3, " array()"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_tag_get_tags', {
    t("tag_get_tags("),
    i(1, "'user'"),
    t(", "),
    i(2, " $userId"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_tag_set_add', {
    t("tag_set_add("),
    i(1, "'user'"),
    t(", "),
    i(2, " $userId"),
    t(", "),
    i(3, " 'chess'"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_tag_set_delete', {
    t("tag_set_delete("),
    i(1, "'user'"),
    t(", "),
    i(2, " $userId"),
    t(", "),
    i(3, " 'chess'"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_tag_description_set', {
    t("tag_description_set($firstTagKey, '<p>TEXT</p>', FORMAT_HTML);"),
  }),

  -- Moodle snippets
  s('mdl_tag_print_cloud', {
    t("tag_print_cloud();"),
  }),

  -- Moodle snippets
  s('mdl_get_user_timezone_offset', {
    t("get_user_timezone_offset();"),
  }),

  -- Moodle snippets
  s('mdl_get_timezone_offset', {
    t("get_timezone_offset();"),
  }),

  -- Moodle snippets
  s('mdl_dst_changes_for_year', {
    t("dst_changes_for_year();"),
  }),

  -- Moodle snippets
  s('mdl_set_module_viewed', {
    t("set_module_viewed("),
    i(1, "$cm"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_add_element_button', {
    t("addElement("),
    i(1, "'button'"),
    t(", "),
    i(2, " 'intro'"),
    t(", "),
    i(3, " get_string('buttonlabel')"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_add_element_checkbox', {
    t("addElement("),
    i(1, "'checkbox'"),
    t(", "),
    i(2, " 'ratingtime'"),
    t(", "),
    i(3, " get_string('ratingtime'"),
    t(", "),
    i(4, " 'forum')"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_add_element_advcheckbox', {
    t("addElement("),
    i(1, "'advcheckbox'"),
    t(", "),
    i(2, " 'ratingtime'"),
    t(", "),
    i(3, " get_string('ratingtime', 'forum')"),
    t(", "),
    i(4, " 'Label displayed after checkbox'"),
    t(", "),
    i(5, "array('group' => 1)"),
    t(", "),
    i(6, " array(0, 1)"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_add_element_choosecoursefile', {
    t("addElement("),
    i(1, "'choosecoursefile'"),
    t(", "),
    i(2, " 'mediafile'"),
    t(", "),
    i(3, " get_string('mediafile', 'lesson')"),
    t(", "),
    i(4, " array('courseid'=>$COURSE->id)"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_add_element_date_time_selector', {
    t("addElement("),
    i(1, "'date_time_selector'"),
    t(", "),
    i(2, " 'assesstimestart'"),
    t(", "),
    i(3, " get_string('from')"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_add_element_select', {
    t("addElement("),
    i(1, "'select'"),
    t(", "),
    i(2, " 'type'"),
    t(", "),
    i(3, " get_string('forumtype', 'forum')"),
    t(", "),
    i(4, " $FORUM_TYPES"),
    t(", "),
    i(5, " $attributes"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_add_element_password', {
    t("addElement("),
    i(1, "'password'"),
    t(", "),
    i(2, " 'password'"),
    t(", "),
    i(3, " get_string('label')"),
    t(", "),
    i(4, " $attributes"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_add_element_hidden', {
    t("addElement("),
    i(1, "'hidden'"),
    t(", "),
    i(2, " 'reply'"),
    t(", "),
    i(3, " 'yes'"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_add_element_html', {
    t("addElement("),
    i(1, "'html'"),
    t(", "),
    i(2, " '<div class=qheader>'"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_add_element_modgrade', {
    t("addElement("),
    i(1, "'modgrade'"),
    t(", "),
    i(2, " 'scale'"),
    t(", "),
    i(3, " get_string('grade')"),
    t(", "),
    i(4, " false"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_add_element_static', {
    t("addElement("),
    i(1, "'static'"),
    t(", "),
    i(2, " 'description'"),
    t(", "),
    i(3, " get_string('description', 'exercise')"),
    t(", "),
    i(4, "get_string('descriptionofexercise', 'exercise'"),
    t(", "),
    i(5, " $COURSE->students)"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_add_element_text', {
    t("addElement("),
    i(1, "'text'"),
    t(", "),
    i(2, " 'name'"),
    t(", "),
    i(3, " get_string('forumname', 'forum')"),
    t(", "),
    i(4, " $attributes"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_add_element_textarea', {
    t("addElement("),
    i(1, "'textarea'"),
    t(", "),
    i(2, " 'introduction'"),
    t(", "),
    i(3, " get_string('introtext', 'survey')"),
    t(", "),
    i(4, " 'wrap=virtual rows=20 cols=50'"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_add_element_recaptcha', {
    t("addElement("),
    i(1, "'recaptcha'"),
    t(", "),
    i(2, " 'recaptcha_field_name'"),
    t(", "),
    i(3, " $attributes"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_add_element_passwordunmask', {
    t("addElement("),
    i(1, "'passwordunmask'"),
    t(", "),
    i(2, " 'password'"),
    t(", "),
    i(3, " get_string('label')"),
    t(", "),
    i(4, " $attributes"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_add_element_selectyesno', {
    t("addElement("),
    i(1, "'selectyesno'"),
    t(", "),
    i(2, " 'maxbytes'"),
    t(", "),
    i(3, " get_string('maxattachmentsize', 'forum')"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_add_element_selectwithlink', {
    t("addElement("),
    i(1, "'selectwithlink'"),
    t(", "),
    i(2, " 'scaleid'"),
    t(", "),
    i(3, " get_string('scale')"),
    t(", "),
    i(4, "$options"),
    t(", "),
    i(5, " null"),
    t(", array("),
    i(6, "'link' => URL"),
    t(", "),
    i(7, " 'label' => get_string('scalescustomcreate')"),
    t("));"),
  }),

  -- Moodle snippets
  s('mdl_add_element_date_selector', {
    t("addElement("),
    i(1, "'date_selector'"),
    t(", "),
    i(2, " 'assesstimefinish'"),
    t(", "),
    i(3, " get_string('to')"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_add_element_duration', {
    t("addElement("),
    i(1, "'duration'"),
    t(", "),
    i(2, " 'timelimit'"),
    t(", "),
    i(3, " get_string('timelimit', 'quiz')"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_add_element_editor', {
    t("addElement("),
    i(1, "'editor'"),
    t(", "),
    i(2, " 'fieldname'"),
    t(", "),
    i(3, " get_string('labeltext', 'langfile')"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_add_element_filepicker', {
    t("addElement("),
    i(1, "'filepicker'"),
    t(", "),
    i(2, " 'userfile'"),
    t(", "),
    i(3, " get_string('file')"),
    t(", "),
    i(4, " null"),
    t(", array("),
    i(5, "'maxbytes' => $maxbytes"),
    t(", "),
    i(6, " 'accepted_types' => '*'"),
    t("));"),
  }),

  -- Moodle snippets
  s('mdl_add_element_filemanager', {
    t("addElement("),
    i(1, "'filemanager'"),
    t(", "),
    i(2, " 'attachments'"),
    t(", "),
    i(3, " get_string('attachment', 'moodle')"),
    t(", "),
    i(4, " null"),
    t(", array("),
    i(5, "'subdirs' => 0"),
    t(", "),
    i(6, " 'maxbytes' => $maxbytes"),
    t(", "),
    i(7, " 'maxfiles' => 50"),
    t(", "),
    i(8, " 'accepted_types' => array('document')"),
    t("));"),
  }),

  -- Moodle snippets
  s('mdl_add_element_tags', {
    t("addElement("),
    i(1, "'tags'"),
    t(", "),
    i(2, " 'field_name'"),
    t(", "),
    i(3, " $lable"),
    t(", "),
    i(4, " $options"),
    t(", "),
    i(5, " $attributes"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_add_element_modvisible', {
    t("addElement("),
    i(1, "'modvisible'"),
    t(", "),
    i(2, " 'visible'"),
    t(", "),
    i(3, " get_string('visible')"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_add_element_grading', {
    t("addElement("),
    i(1, "'grading'"),
    t(", "),
    i(2, " 'advancedgrading'"),
    t(", "),
    i(3, " get_string('grade').':'"),
    t(", "),
    i(4, " array('gradinginstance' => $gradinginstance)"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_add_element_questioncategory', {
    t("addElement("),
    i(1, "'questioncategory'"),
    t(", "),
    i(2, " 'category'"),
    t(", "),
    i(3, " get_string('category', 'question')"),
    t(", array("),
    i(4, "'contexts'=>$contexts"),
    t(", "),
    i(5, " 'top'=>true"),
    t(", "),
    i(6, " 'currentcat'=>$currentcat"),
    t(", "),
    i(7, " 'nochildrenof'=>$currentcat"),
    t("));"),
  }),

  -- Moodle snippets
  s('mdl_context_system_instance', {
    t("context_system::instance();"),
  }),

  -- Moodle snippets
  s('mdl_context_user_instance', {
    t("context_user::instance("),
    i(1, "$user->id"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_context_coursecat_instance', {
    t("context_coursecat::instance("),
    i(1, "$category->id"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_context_course_instance', {
    t("context_course::instance("),
    i(1, "$course->id"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_context_module_instance', {
    t("context_module::instance("),
    i(1, "$cm->id"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_context_instance_by_id', {
    t("context::instance_by_id("),
    i(1, "$contextid"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_html_writer_table', {
    t("html_writer::table("),
    i(1, "$table"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_html_select_make', {
    t("html_select::make("),
    i(1, "$options"),
    t(", "),
    i(2, " 'choice1'"),
    t(", "),
    i(3, " 'value1'"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_html_select_make_time_selector', {
    t("html_select::make_time_selector("),
    i(1, "'days'"),
    t(", "),
    i(2, " 'myday'"),
    t(", "),
    i(3, " '120308000'"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_event_create', {
    t("calendar_event::create("),
    i(1, "$properties"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_calendar_event_update', {
    t("calendar_event::update("),
    i(1, "$data"),
    t(", "),
    i(2, " $checkcapability = true"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_capabilities', {
    t("$capabilities = array('"),
    i(1, "mod"),
    t("/"),
    i(2, "MYPLUGIN"),
    t(":"),
    i(3, "MYCAPABILITY"),
    t("' => array('riskbitmask' => "),
    i(4, "RISK_SPAM"),
    t(", 'captype' => "),
    i(5, "'write'"),
    t(", 'contextlevel' =>"),
    i(6, "CONTEXT_MODULE"),
    t(", 'archetypes' => array("),
    i(7, "'editingteacher' => CAP_ALLOW"),
    t(")));"),
  }),

  -- Moodle snippets
  s('mdl_fileinfo', {
    t("$fileinfo = array("),
    i(1, "'contextid' => $context->id"),
    t(", "),
    i(2, " 'component' => 'mod_MYMOD'"),
    t(", "),
    i(3, " 'filearea' => 'myarea'"),
    t(", "),
    i(4, " 'itemid' => 0"),
    t(", "),
    i(5, " 'filepath' => '/'"),
    t(", "),
    i(6, " 'filename' => 'myfile.txt'"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_handlers', {
    t("$handlers = array("),
    i(1, " 'user_enrolled'"),
    t(" => array ('handlerfile' => "),
    i(2, "'/mod/MYMOD/lib.php'"),
    t(", 'handlerfunction' => "),
    i(3, "'MYMODFUNCTION'"),
    t(", 'schedule' => "),
    i(4, "'instant'"),
    t(", 'internal' => "),
    i(5, " 1"),
    t("));"),
  }),

  -- Moodle snippets
  s('mdl_messageproviders', {
    t("$messageproviders = array ("),
    i(1, "'MYPROVIDER' => array ()"),
    t(");"),
  }),

  -- Moodle snippets
  s('mdl_plugin_version', {
    t("$plugin->version"),
  }),

  -- Moodle snippets
  s('mdl_plugin_requires', {
    t("$plugin->requires"),
  }),

  -- Moodle snippets
  s('mdl_plugin_dependencies', {
    t("$plugin->dependencies"),
  }),

  -- This method is used to hide repositories when they don't support certain file types - for example, if a user is inserting a video then any repository which does not support videos will not be shown.
  s('mdl_supported_filetypes', {
    t({"function supported_filetypes() {", "	// Allow any kind of file.", "	return '*';", "}"}),
  }),

  -- Optional. Return an array of string. These strings are setting names. These settings are shared by all instances. Parent function returns an array with a single item - pluginname.
  s('mdl_get_type_option_names', {
    t({"public static function get_type_option_names() {", "	// Return a list of option names that are valid for this plugin.", "	return array_merge(parent::get_type_option_names(), ['rootpath']);", "}"}),
  }),

  -- Optional. This is for modifying the Moodle form displaying the plugin settings. The Form Definition documentation has details of all the types of elements you can add to the settings form.
  s('mdl_type_config_form', {
    t({"public static function type_config_form($mform, $classname='repository') {", "	parent: :type_config_form($mform);", "", "	$rootpath = get_config('repository_pluginname', 'rootpath');", "	$mform->addElement('text', 'rootpath', get_string('rootpath', 'repository_pluginname'), array('size' => '40'));", "	$mform->setDefault('rootpath', $rootpath);", "}"}),
  }),

  -- Optional. Use this function if you need to validate some variables submitted by plugin settings form.
  s('mdl_type_form_validation', {
    t({"public static function type_form_validation($mform, $data, $errors) {", "	if (!is_dir($data['rootpath'])) {", "		$errors['rootpath'] = get_string('invalidrootpath', 'repository_pluginname');", "	}", "	return $errors;", "}"}),
  }),

  -- Optional. Return an array of strings. These strings are setting names. These settings are specific to an instance.
  s('mdl_get_instance_option_names', {
    t({"public static function get_instance_option_names() {", "	return ['fs_path']; // From repository_filesystem", "}"}),
  }),

  -- Optional. This is for modifying the Moodle form displaying the settings specific to an instance.
  s('mdl_instance_config_form', {
    t({"public static function get_instance_option_names() {", "	$mform->addElement(", "		'text',", "		'email_address',", "		get_string('emailaddress', 'repository_pluginname')", "	);", "	$mform->addRule('email_address', $strrequired, 'required', null, 'client');", "}"}),
  }),

  -- Comment block with author of this file for Moodle.
  s('mdl_moodle_comment', {
    t({"/**", " * "}),
    i(1, "short_description"),
    t({"", " *", " * "}),
    i(2, "long_description"),
    t({"", " *", " * @package    "}),
    i(3, "package"),
    t("_"),
    i(4, "subpackage"),
    t({"", " * @copyright  "}),
    i(5),
    t(" "),
    i(6, "author_fullname"),
    t(" <"),
    i(7, "author_link"),
    t({">", " * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later", " */"}),
  }),

}
