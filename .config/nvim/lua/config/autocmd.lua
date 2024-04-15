local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
-- local usercmd = vim.api.nvim_create_user_command

local SaldanhaGroup = augroup("Saldanha", {})
local YankGroup = augroup("YankHighlight", {})

-- Highlight on yank
autocmd("TextYankPost", {
    group = YankGroup,
    callback = function()
        vim.highlight.on_yank({ timeout = "150" })
    end,
})

-- Remove whitespace on save
autocmd({ "BufWritePre" }, {
    group = SaldanhaGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

-- Don't auto commenting new lines
autocmd({ "BufEnter" }, {
    group = SaldanhaGroup,
    pattern = "",
    command = "set fo-=c fo-=r fo-=o",
})

-- Resize splits if window got resized
-- see `:h VimResized`
autocmd("VimResized", {
    group = SaldanhaGroup,
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd("tabdo wincmd =")
        vim.cmd("tabnext " .. current_tab)
    end,
})

-- LSP keybindings
-- see `:h lsp`
autocmd("LspAttach", {
    group = SaldanhaGroup,
    callback = function(e)
        local opts = function(desc)
            return { desc = desc, noremap = true, silent = true, buffer = e.buf }
        end
        vim.keymap.set("n", "gd", function()
            vim.lsp.buf.definition()
        end, opts("[LSP] Go to definition"))
        vim.keymap.set("n", "K", function()
            vim.lsp.buf.hover()
        end, opts("[LSP] Hover"))
        vim.keymap.set("n", "<leader>ca", function()
            vim.lsp.buf.code_action()
        end, opts("[LSP] Code action"))
        vim.keymap.set("n", "<leader>cR", function()
            vim.lsp.buf.references()
        end, opts("[LSP] References"))
        vim.keymap.set("n", "<leader>cD", function()
            vim.diagnostic.open_float()
        end, opts("[LSP] Diagnostics"))
        vim.keymap.set("n", "<leader>cr", function()
            vim.lsp.buf.rename()
        end, opts("[LSP] Rename"))
        vim.keymap.set("n", "[d", function()
            vim.diagnostic.goto_next()
        end, opts("[LSP] Next diagnostic"))
        vim.keymap.set("n", "]d", function()
            vim.diagnostic.goto_prev()
        end, opts("[LSP] Previous diagnostic"))
        vim.keymap.set("i", "<C-h>", function()
            vim.lsp.buf.signature_help()
        end, opts("[LSP] Signature help"))
        -- TODO: Check it out thi workspace thing
        -- vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts("[LSP] Workspace symbols"))
    end,
})
