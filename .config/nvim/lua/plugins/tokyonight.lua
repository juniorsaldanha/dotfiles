return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function()
    require("tokyonight").setup({
      style = "moon",
      light_style = "day",
      terminal_colors = true,
      on_colors = function(colors)
        colors.error = colors.red
        colors.hint = colors.orange
      end,
    })
    vim.cmd("colorscheme tokyonight-night")
  end,
}
