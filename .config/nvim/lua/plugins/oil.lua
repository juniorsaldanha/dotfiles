--[[
  Oil.nvim - File explorer

  KEYMAPS: Modify keymaps in the `keys` section
]]

return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- ========================================================================
    -- KEYMAPS
    -- ========================================================================
    keys = {
        { "-", "<cmd>Oil<CR>", desc = "Open parent directory" },
        { "<leader>o", "<cmd>Oil --float<CR>", desc = "Open Oil (float)" },
    },
    opts = {
        columns = { "icon" },
        keymaps = {
            ["<C-h>"] = false,
            ["<C-l>"] = false,
            ["<C-j>"] = false,
            ["<C-k>"] = false,
            ["<M-h>"] = "actions.select_split",
        },
        view_options = {
            show_hidden = true,
        },
    },
}
