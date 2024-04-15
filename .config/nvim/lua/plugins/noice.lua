return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
    opts = {},
    keys = {
        { "<leader>nc", "<cmd>Noice dismiss<cr>", { noremap = true, silent = true } },
        { "<leader>nt", "<cmd>NoiceTelescope<cr>", { noremap = true, silent = true } },
    },
    config = function()
        require("noice").setup({
            routes = {
                {
                    filter = {
                        event = "msg_show",
                        kind = "",
                        find = "Pick window",
                    },
                    opts = { skip = true },
                },
                {
                    filter = {
                        event = "msg_show",
                        kind = "",
                        find = "written",
                    },
                    opts = { skip = true },
                },
                {
                    filter = {
                        event = "msg_show",
                        kind = "more lines",
                        find = "more lines",
                    },
                    opts = { skip = true },
                },
                {
                    filter = {
                        event = "msg_show",
                        kind = "Plugin Updates",
                        find = "Plugin Updates",
                    },
                    opts = { skip = true },
                },
            },
        })
    end,
}
