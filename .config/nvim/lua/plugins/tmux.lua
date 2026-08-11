--[[
  vim-tmux-navigator - Seamless tmux/vim pane navigation

  Mappings are defined here (normal mode only) instead of using the
  plugin's own default <C-h/j/k/l> mappings. The plugin's defaults also
  map terminal mode, which races with claudecode.nvim's auto_insert
  (re-enters terminal mode on focus): the mapping's <C-\><C-n> mode-exit
  gets undone mid-sequence, and the rest of the mapping ("TmuxNavigateLeft")
  gets typed as literal text into the terminal instead of executing.
  Normal-mode-only mappings avoid that: inside any terminal buffer
  (Claude, lazygit, floaterm apps) <C-h/j/k/l> just pass through untouched.
]]

return {
  "christoomey/vim-tmux-navigator",
  init = function()
    vim.g.tmux_navigator_no_mappings = 1
  end,
  keys = {
    { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Go to left window" },
    { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Go to lower window" },
    { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Go to upper window" },
    { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Go to right window" },
    { "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Go to previous window" },
  },
}
