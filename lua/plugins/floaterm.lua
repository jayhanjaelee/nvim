return {
  "nvzone/floaterm",
  dependencies = "nvzone/volt",
  opts = {
    border = false,
    size = { h = 70, w = 80 },

    -- to use, make this func(buf)
    mappings = { sidebar = nil, term = nil },

    -- Default sets of terminals you'd like to open
    terminals = {
      { name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t") },
    },
  },
  config = function(_, opts)
    require("floaterm").setup(opts)

    local state = require("floaterm.state")

    local function redraw_ui()
      pcall(function()
        if state.barbuf and vim.api.nvim_buf_is_valid(state.barbuf) then
          require("volt").redraw(state.barbuf, "bar")
        end
        if state.sidebuf and vim.api.nvim_buf_is_valid(state.sidebuf) then
          require("volt").redraw(state.sidebuf, "bufs")
        end
      end)
    end

    -- 비동기 프로세스명 감지 후 터미널 이름 업데이트
    local function update_term_name_async(term)
      if not (term.buf and vim.api.nvim_buf_is_valid(term.buf)) then return end
      local ok, chan = pcall(function() return vim.bo[term.buf].channel end)
      if not ok or not chan or chan <= 0 then return end
      local pid_ok, pid = pcall(vim.fn.jobpid, chan)
      if not pid_ok or not pid then return end

      local shell_name
      local cmd
      if vim.fn.has("win32") == 1 then
        shell_name = vim.fn.fnamemodify(vim.o.shell, ":t"):gsub("%.exe$", "")
        cmd = {
          "powershell", "-NoProfile", "-Command",
          "$procs = Get-CimInstance Win32_Process | Where-Object {$_.ParentProcessId -eq " .. pid .. "};"
            .. "if ($procs) { ($procs | Select-Object -Last 1).Name } else { '' }",
        }
      else
        shell_name = vim.fn.fnamemodify(vim.o.shell, ":t")
        cmd = { "sh", "-c", "ps -o comm= -p $(ps -o tpgid= -p " .. pid .. " | tr -d ' ') 2>/dev/null" }
      end

      vim.system(cmd, { text = true }, function(out)
        vim.schedule(function()
          local fg_proc = vim.trim(out.stdout or "")
          if vim.fn.has("win32") == 1 then
            fg_proc = fg_proc:gsub("%.exe$", "")
          else
            fg_proc = vim.fn.fnamemodify(fg_proc, ":t")
          end

          if fg_proc == "" or fg_proc == shell_name then
            -- 셸만 실행 중 → cwd 표시 (OSC 7이 처리하므로 여기선 폴백)
            if not term._osc7_name then
              local cwd_cmd
              if vim.fn.has("win32") == 1 then
                cwd_cmd = {
                  "powershell", "-NoProfile", "-Command",
                  "(Get-CimInstance Win32_Process -Filter 'ProcessId=" .. pid .. "').ExecutablePath | Split-Path",
                }
              else
                cwd_cmd = { "sh", "-c", "lsof -a -d cwd -p " .. pid .. " 2>/dev/null | tail -1 | awk '{print $NF}'" }
              end
              vim.system(cwd_cmd, { text = true }, function(cwd_out)
                vim.schedule(function()
                  local cwd = vim.trim(cwd_out.stdout or "")
                  if cwd ~= "" then
                    term.name = vim.fn.fnamemodify(cwd, ":t")
                  else
                    term.name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
                  end
                  term._osc7_name = nil
                  redraw_ui()
                end)
              end)
            end
          else
            term._osc7_name = nil
            term.name = fg_proc
            redraw_ui()
          end
        end)
      end)
    end

    local augroup = vim.api.nvim_create_augroup("FloatermDynName", { clear = true })

    -- OSC 7: 셸이 디렉토리 변경 시 즉각 반영
    vim.api.nvim_create_autocmd("TermRequest", {
      group = augroup,
      callback = function(args)
        local req = args.data and args.data.sequence or ""
        if not req:match("^\27]7;") then return end
        local path = req:match("^\27]7;file://[^/]*(/.+)\a?$") or req:match("^\27]7;file://[^/]*(/.+)$")
        if not path then return end
        path = vim.uri_decode(path)
        for _, t in ipairs(state.terminals or {}) do
          if t.buf == args.buf then
            t.name = vim.fn.fnamemodify(path, ":t")
            t._osc7_name = true
            redraw_ui()
            break
          end
        end
      end,
    })

    -- 프로세스명 폴링: floaterm 열려 있을 때만 300ms 간격
    local poll_timer = vim.uv.new_timer()
    poll_timer:start(500, 300, vim.schedule_wrap(function()
      if not state.volt_set then return end
      for _, term in ipairs(state.terminals or {}) do
        update_term_name_async(term)
      end
    end))
  end,
  cmd = "FloatermToggle",
  keys = {
    { "<M-t>", "<cmd>FloatermToggle<CR>", desc = "Toggle Floaterm", mode = { "n", "t" } },
  },
}