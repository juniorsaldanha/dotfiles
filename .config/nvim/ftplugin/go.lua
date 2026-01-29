-- Set the column guide
vim.opt_local.colorcolumn = "120"

-- Go-specific indentation (Standard Go uses tabs, not spaces)
vim.opt_local.expandtab = false
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4

-- Optional: Auto-format on save using LSP
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        -- This calls the LSP formatting sync
        vim.lsp.buf.format({ async = false })

        -- Optional: If you use 'goimports', you can add logic here
        -- to organize imports automatically.
    end,
})
