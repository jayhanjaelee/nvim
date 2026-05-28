return {
  "AndrewRadev/linediff.vim",
  cmd = "Linediff",  -- 명령어 호출 시 lazy load
  keys = {
    { "<leader>ld", ":Linediff<CR>", mode = "v", desc = "Linediff" },
    { "<leader>lr", ":LinediffReset<CR>", desc = "Linediff Reset" },
  },
}
