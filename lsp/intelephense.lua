return {
  cmd = { 'intelephense', '--stdio' },
  filetypes = { 'php' },
  root_markers = { 'composer.json', '.git' },
  settings = {
    intelephense = {
      environment = {
        includePaths = {
          'public/lib/classes',
          'lib/classes'
        },
      },
      diagnostics = {
        undefinedTypes = false,
        undefinedFunctions = false,
        undefinedConstants = false,
        undefinedClassConstants = false,
        undefinedMethods = false,
        undefinedProperties = false,
        undefinedVariables = false -- Moodle 전역변수($CFG, $DB, $PAGE 등) 오탐(P1008) 방지
      },
    },
  },
}
