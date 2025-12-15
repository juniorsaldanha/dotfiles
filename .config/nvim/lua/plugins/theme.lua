--[[
  Theme - Tokyonight

  Change the colorscheme by modifying the vim.cmd line at the bottom
  Options: tokyonight-night, tokyonight-storm, tokyonight-day, tokyonight-moon
]]

return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "night",
    transparent = false,
    terminal_colors = true,
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      sidebars = "dark",
      floats = "dark",
    },
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd.colorscheme("tokyonight-night")
  end,
}
