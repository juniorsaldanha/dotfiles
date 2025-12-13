--[[
  Treesitter - Syntax highlighting and code understanding

  LANGUAGES: Add/remove parsers in the `ensure_installed` table
]]

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        -- ====================================================================
        -- PARSERS TO AUTO-INSTALL
        -- Add or remove languages here
        -- ====================================================================
        ensure_installed = {
            "bash",
            "c",
            "css",
            "go",
            "html",
            "javascript",
            "jsdoc",
            "json",
            "lua",
            "luadoc",
            "markdown",
            "markdown_inline",
            "python",
            "rust",
            "typescript",
            "vim",
            "vimdoc",
            "yaml",
        },
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = true,
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<C-space>",
                node_incremental = "<C-space>",
                scope_incremental = false,
                node_decremental = "<bs>",
            },
        },
    },
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end,
}
