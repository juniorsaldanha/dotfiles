return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    lazygit = { enabled = true },
    picker = { enabled = true },
    git = { enabled = true },
    gitbrowser = { enabled = true },
    zen = { enabled = true },
  },
  keys = {
    { "<leader>gl",  function() Snacks.lazygit() end,                      desc = "[g]it [l]azyGit" },
    { "<leader>z",   function() Snacks.zen() end,                          desc = "[z]en" },
    { "<leader>gbl", function() Snacks.git.blame_line() end,               desc = "[g]it [B]lame [L]ine" },
    { "<leader>gb",  function() Snacks.gitbrowse() end,                    desc = "[g]it [B]rowser" },
    { "gd",          function() Snacks.picker.lsp_definitions() end,       desc = "[g]oto [d]efinition" },
    { "gD",          function() Snacks.picker.lsp_declarations() end,      desc = "[g]oto [D]eclaration" },
    { "gr",          function() Snacks.picker.lsp_references() end,        nowait = true,                     desc = "[g]oto [r]eferences" },
    { "gI",          function() Snacks.picker.lsp_implementations() end,   desc = "[g]oto [I]mplementation" },
    { "gy",          function() Snacks.picker.lsp_type_definitions() end,  desc = "[g]oto T[y]pe Definition" },
    { "<leader>ss",  function() Snacks.picker.lsp_symbols() end,           desc = "L[s]P [s]ymbols" },
    { "<leader>sS",  function() Snacks.picker.lsp_workspace_symbols() end, desc = "L[s]P Workspace [S]ymbols" },
  },
}
