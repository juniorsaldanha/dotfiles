-- NOTE: Check all the opts for trouble and configure it property (with description for whichkey)
-- WARN: Add keymaps for the trouble (diagnostics, todo, error messages)
return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    signs = {
      error = "",
      warning = "",
      hint = "",
      information = "",
    },
    use_diagnostic_signs = true,
  },
}
