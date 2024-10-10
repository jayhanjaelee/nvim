return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
    },
    config = function()
      local dap = require("dap")
      local ui = require("dapui")

      local phpDapSrc = nil;
      local osname = vim.loop.os_uname().sysname
      if osname == 'Darwin' then
        -- unix
        phpDapSrc = os.getenv("HOME") .. "/vscode-php-debug/out/phpDebug.js"
      elseif string.find(osname, "Windows") then
      -- windows
        phpDapSrc = os.getenv("USERPROFILE") .. "/vscode-php-debug/out/phpDebug.js"
      end

      -- change symbol color for breakpoint
      vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#e86671', bg = '#282c34' })
      vim.fn.sign_define('DapBreakpoint', {text='B', texthl='DapBreakpoint', linehl='', numhl=''})

      -- php
      dap.adapters.php = {
        type = "executable",
        command = "node",
        -- change this to where you build vscode-php-debug
        args = { phpDapSrc },
      }

      dap.configurations.php = {
        {
          type = "php",
          request = "launch",
          name = "Listen for Xdebug",
          port = 9003,
        },
        -- to run php right from the editor
        -- {
        --   name = "run current script",
        --   type = "php",
        --   request = "launch",
        --   port = 9003,
        --   cwd = "${fileDirname}",
        --   program = "${file}",
        --   runtimeExecutable = "php",
        -- },
      }

      require("dapui").setup()

      require("nvim-dap-virtual-text").setup({
        enabled = true,                        -- enable this plugin (the default)
        enabled_commands = true,               -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
        highlight_changed_variables = true,    -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
        highlight_new_as_changed = false,      -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
        show_stop_reason = true,               -- show stop reason when stopped for exceptions
        commented = false,                     -- prefix virtual text with comment string
        only_first_definition = true,          -- only show virtual text at first definition (if there are multiple)
        all_references = false,                -- show virtual text on all all references of the variable (not only definitions)
        clear_on_continue = false,             -- clear virtual text on "continue" (might cause flickering when stepping)
        display_callback = function(variable, buf, stackframe, node, options)
          -- by default, strip out new line characters
          if options.virt_text_pos == 'inline' then
            return ' = ' .. variable.value:gsub("%s+", " ")
          else
            return variable.name .. ' = ' .. variable.value:gsub("%s+", " ")
          end
        end,
        -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
        virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',

        -- experimental features:
        all_frames = false,                    -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
        virt_lines = false,                    -- show virtual lines instead of virtual text (will flicker!)
        virt_text_win_col = nil                -- position the virtual text at a fixed window column (starting from the first text column) ,
        -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
      })

      vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
      vim.keymap.set("n", "<space>gb", dap.run_to_cursor)
      vim.keymap.set("n", "<leader>c", ":lua require'dap'.clear_breakpoints()<cr>", { silent = true })

      -- Eval var under cursor
      vim.keymap.set("n", "<space>?", function()
        require("dapui").eval(nil, { enter = true })
      end)

      vim.keymap.set("n", "<leader>do", ":lua require'dapui'.open()<cr>", { silent = true })
      vim.keymap.set("n", "<leader>dt", ":lua require'dapui'.toggle()<cr>", { silent = true })
      vim.keymap.set("n", "<leader>dc", ":lua require'dapui'.close()<cr>", { silent = true })
      vim.keymap.set("n", "<F1>", dap.continue)
      vim.keymap.set("n", "<F2>", dap.step_into)
      vim.keymap.set("n", "<F3>", dap.step_over)
      vim.keymap.set("n", "<F4>", dap.step_out)
      vim.keymap.set("n", "<F5>", dap.step_back)
      vim.keymap.set("n", "<F6>", dap.restart)

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end
    end,
  },
}
