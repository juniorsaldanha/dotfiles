local config = require("utils.config")
local M = {}
M.toggle_transparent = function()
  config.Toggle_transparent()
  vim.notify(
    "Transparency "
    .. (config.Get_transparent() and "Enabled" or "Disabled"),
    vim.log.levels.INFO,
    { title = "Transparency Toggle" }
  )
  vim.cmd("Lazy reload tokyonight.nvim")
end

return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  -- opts = {},
  config = function()
    local tokyo = require("tokyonight")
    tokyo.setup({
      style = "night",
      light_style = "day",
      terminal_colors = true,
      transparent = config.Get_transparent(),
      on_colors = function(colors)
        colors.error = colors.red
        colors.hint = colors.orange
      end,
    })
    vim.cmd("colorscheme tokyonight")

    local usercmd = vim.api.nvim_create_user_command
    usercmd("ToggleTransparency", M.toggle_transparent, {
      desc = "Toggle Transparency",
      nargs = "?"
    })
  end,

}
