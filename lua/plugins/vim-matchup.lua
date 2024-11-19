return {
  {
    "andymass/vim-matchup",
    config = function()
      -- Additional configuration (optional)
      vim.g.matchup_matchparen_enabled = 1  -- Enable match-up features for `%`
      vim.g.matchup_surround_enabled = 1    -- Enable matching for surrounding text
    end,
  },
}
