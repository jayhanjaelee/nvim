return {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose" },
  root_markers = { '.git' },
  settings = {
    yaml = {
      validate = true,
      schemaStore = {
        enable = true,
      },
    },
  },
}
