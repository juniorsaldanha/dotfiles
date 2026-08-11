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

        local transparent = false
        vim.api.nvim_create_user_command("TransparentToggle", function()
            transparent = not transparent
            if transparent then
                for _, grp in ipairs({ "Normal", "NormalNC", "NonText", "SignColumn", "EndOfBuffer" }) do
                    vim.api.nvim_set_hl(0, grp, { bg = "none" })
                end
            else
                vim.cmd.colorscheme("tokyonight-night")
            end
        end, {})
    end,
}
