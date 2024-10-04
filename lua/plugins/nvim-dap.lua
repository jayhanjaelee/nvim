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

      local phpDapSrc = os.getenv("USERPROFILE") .. "/vscode-php-debug/out/phpDebug.js"
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
        -- enabled = true,
        -- enabled_commands = true,
        -- highlight_changed_variables = true,
        -- highlight_new_as_changed = false,
        -- show_stop_reason = true,
        -- commented = false,
        -- only_first_definition = true,
        -- all_references = false,
        -- clear_on_continue = false,
        -- display_callback = function() end,
      })

      vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
      vim.keymap.set("n", "<space>gb", dap.run_to_cursor)

      -- Eval var under cursor
      vim.keymap.set("n", "<space>?", function()
        require("dapui").eval(nil, { enter = true })
      end)

      vim.keymap.set("n", "<F1>", dap.continue)
      vim.keymap.set("n", "<F2>", dap.step_into)
      vim.keymap.set("n", "<F3>", dap.step_over)
      vim.keymap.set("n", "<F4>", dap.step_out)
      vim.keymap.set("n", "<F5>", dap.step_back)
      vim.keymap.set("n", "<F13>", dap.restart)

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
