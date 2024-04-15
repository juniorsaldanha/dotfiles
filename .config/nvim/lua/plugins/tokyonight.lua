return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function()
    local tokyo = require("tokyonight")
    tokyo.setup({
      style = "night",
      light_style = "day",
      terminal_colors = true,
      transparent = false,
      on_colors = function(colors)
        colors.error = colors.red
        colors.hint = colors.orange
      end,
    })
    vim.cmd("colorscheme tokyonight")
  end,
}
