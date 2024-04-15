return {
    "mbbill/undotree",
    config = function()
        vim.keymap.set(
            "n",
            "<leader>u",
            vim.cmd.UndotreeToggle,
            { desc = "Undotree Toggle", noremap = true, silent = true }
        )
    end,
}
