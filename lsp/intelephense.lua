return {
  cmd = { 'intelephense', '--stdio' },
  filetypes = { 'php' },
  root_markers = { 'composer.json', '.git' },
  diagnostics = {
    undefinedTypes = false,
    undefinedFunctions = false,
    undefinedConstants = false,
    undefinedClassConstants = false,
    undefinedMethods = false,
    undefinedProperties = false,
    undefinedVariables = true
  }
}
