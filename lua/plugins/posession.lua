return {
  'jedrzejboczar/possession.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('possession').setup{
      silent = false,
      load_silent = true,
      debug = false,
      logfile = false,
      prompt_no_cr = true,
      autosave = {
        current = true,  -- or fun(name): boolean
        cwd = true, -- or fun(): boolean
        tmp = false,  -- or fun(): boolean
        tmp_name = 'tmp', -- or fun(): string
        on_load = true,
        on_quit = true,
      },
      autoload = 'last_cwd', -- or 'last' or 'auto_cwd' or 'last_cwd' or fun(): string
      commands = {
        save = 'SSave',
        load = 'SLoad',
        save_cwd = 'SSaveCwd',
        load_cwd = 'SLoadCwd',
        rename = 'SRename',
        close = 'SClose',
        delete = 'SDelete',
        show = 'SShow',
        list = 'SList',
        list_cwd = 'SListCwd',
        migrate = 'SMigrate',
      },
      hooks = {
        before_save = function(name) return {} end,
        after_save = function(name, user_data, aborted) end,
        before_load = function(name, user_data) return user_data end,
        after_load = function(name, user_data) end,
      },
      plugins = {
        close_windows = {
          hooks = {'before_save', 'before_load'},
          preserve_layout = true,  -- or fun(win): boolean
          match = {
            floating = true,
            buftype = {},
            filetype = {},
            custom = false,  -- or fun(win): boolean
          },
        },
        delete_hidden_buffers = {
          hooks = {
            'before_load',
            vim.o.sessionoptions:match('buffer') and 'before_save',
          },
          force = false,  -- or fun(buf): boolean
        },
        nvim_tree = true,
        neo_tree = true,
        symbols_outline = true,
        outline = true,
        tabby = true,
        dap = true,
        dapui = true,
        neotest = true,
        delete_buffers = false,
        stop_lsp_clients = false,
      },
      telescope = {
        previewer = {
          enabled = true,
          previewer = 'pretty', -- or 'raw' or fun(opts): Previewer
          wrap_lines = true,
          include_empty_plugin_data = false,
          cwd_colors = {
            cwd = 'Comment',
            tab_cwd = { '#cc241d', '#b16286', '#d79921', '#689d6a', '#d65d0e', '#458588' }
          }
        },
        list = {
          default_action = 'load',
          mappings = {
            save = { n = '<c-s>', i = '<c-s>' },
            load = { n = '<c-l>', i = '<c-l>' },
            delete = { n = '<c-d>', i = '<c-d>' },
            rename = { n = '<c-r>', i = '<c-r>' },
          },
        },
      },
    }

    vim.keymap.set("n", "<leader>sa", ":SSave<cr>")
    vim.keymap.set("n", "<leader>sl", ":SLoad<cr>")
    vim.keymap.set("n", "<leader>sd", ":SDelete<cr>")
    vim.keymap.set("n", "<leader>sr", ":SRename<cr>")
  end
}
