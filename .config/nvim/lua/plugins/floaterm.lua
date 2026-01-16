return {
    -- dir = "~/gh/floaterm.nvim/",
    "juniorsaldanha/floaterm.nvim",
    config = function()
        local floaterm = require("floaterm")
        floaterm.setup()
        --
        floaterm.register_terminal("terminal_backslash", "<C-_>", {
            width = 0.9,
            height = 0.9,
            -- border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
            border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
        })
        floaterm.register_terminal("terminal1", "<leader>t1")
        floaterm.register_terminal("terminal2", "<leader>t2")
        floaterm.register_terminal("terminal3", "<leader>t3")
        floaterm.register_app("lazygit", "<leader>lg", "lazygit")
        floaterm.register_app("claude", "<leader>ai1", "claude", {
            width = 0.9,
            height = 0.9,
        })
        floaterm.register_app("crush", "<leader>ai2", "crush", {
            width = 0.9,
            height = 0.9,
        })
        floaterm.register_app("gemini", "<leader>ai3", "gemini", {
            width = 0.9,
            height = 0.9,
        })
        floaterm.register_app("opencode", "<leader>ai4", "opencode", {
            width = 0.9,
            height = 0.9,
        })
        floaterm.register_app("btop", "<leader>bt", "btop", {
            width = 0.9,
            height = 0.9,
        })
    end,
}
