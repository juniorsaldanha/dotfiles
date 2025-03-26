if vim.g.vscode then
    local vscode = require("vscode")
    -- VSCode extension
    vim.g.mapleader = ' '
    vim.g.clipboard = vim.g.vscode_clipboard

    vim.keymap.set({'i', 'n', 'v'}, "<ESC>", "<ESC>:noh<CR>")
    vim.keymap.set({'n', 'v'}, "<C-l>", "<C-w>l") -- move to right window
    vim.keymap.set({'n', 'v'}, "<C-h>", "<C-w>h") -- move to left window
    vim.keymap.set({'n', 'v'}, "<C-j>", "<C-w>j") -- move to down window
    vim.keymap.set({'n', 'v'}, "<C-k>", "<C-w>k") -- move to up window
    vim.keymap.set({ "n", "x" }, "<leader>r", function()
        vscode.with_insert(function()
            vscode.action("editor.action.refactor")
        end)
    end)
else
    -- ordinary Neovim
    require("config.options")
    require("config.autocmd")
    require("config.keymaps")
    require("config.lazy")
end