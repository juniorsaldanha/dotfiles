--[[
  claudecode.nvim - Claude Code IDE integration
  https://github.com/coder/claudecode.nvim

  Talks to the Claude Code CLI over its WebSocket MCP protocol: sends
  buffer/selection context and opens native diffs for proposed edits.
  Complements (doesn't replace) the plain `claude` CLI launched via
  floaterm (<leader>aic) which has no editor integration.

  No snacks.nvim dependency: provider = "auto" (default) falls back to
  the plugin's built-in zero-dependency "native" terminal provider.

  KEYMAPS: Modify the `keys` section below
]]

return {
  "coder/claudecode.nvim",
  cmd = {
    "ClaudeCode",
    "ClaudeCodeFocus",
    "ClaudeCodeSelectModel",
    "ClaudeCodeAdd",
    "ClaudeCodeSend",
    "ClaudeCodeTreeAdd",
    "ClaudeCodeStatus",
    "ClaudeCodeStart",
    "ClaudeCodeStop",
    "ClaudeCodeOpen",
    "ClaudeCodeClose",
    "ClaudeCodeDiffAccept",
    "ClaudeCodeDiffDeny",
    "ClaudeCodeCloseAllDiffs",
  },
  config = true,
  -- ========================================================================
  -- KEYMAPS
  -- ========================================================================
  keys = {
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude Code" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude Code" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude Code" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
    { "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", desc = "Add file to Claude", ft = { "oil" } },
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  },
}
