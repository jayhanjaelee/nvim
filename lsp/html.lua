return {
  cmd = { "vscode-html-language-server", "--stdio" },
  filetypes = { "html", "templ" },
  root_markers = { 'package.json', '.git' },
  init_options = {
    provideFormatter = true,
  },
}
