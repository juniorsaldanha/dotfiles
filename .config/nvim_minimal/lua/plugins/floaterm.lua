return {
  dir = "~/gh/floaterm.nvim/",
  config = function()
    local floaterm = require("floaterm")
    floaterm.setup()

    floaterm.register_terminal("terminal_backslash", "<C-_>", {
      width = 0.9,
      height = 0.9,
      border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
    })
    floaterm.register_terminal("terminal1", "<leader>1")
    floaterm.register_terminal("terminal2", "<leader>2")
    floaterm.register_terminal("terminal3", "<leader>3")
  end,
}
