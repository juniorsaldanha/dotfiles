local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
-- local usercmd = vim.api.nvim_create_user_command

local YankGroup = augroup("YankHighlight", {})
local CustomGroup = augroup("Saldanha", {})

-- Highlight on yank
autocmd("TextYankPost", {
  group = YankGroup,
  callback = function()
    vim.highlight.on_yank({ timeout = "150" })
  end,
})

-- Remove whitespace on save
autocmd({ "BufWritePre" }, {
  group = CustomGroup,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- Resize splits if window got resized
-- see `:h VimResized`
autocmd("VimResized", {
  group = CustomGroup,
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- LSP keybindings
-- see `:h lsp`
autocmd("LspAttach", {
  group = CustomGroup,
  callback = function(e)
    local opts = function(desc)
      return { desc = desc, noremap = true, silent = true, buffer = e.buf }
    end
    local map = vim.keymap.set
    local lspbuf = vim.lsp.buf
    local lspdiag = vim.diagnostic
    map("n", "gd", function()
      lspbuf.definition()
    end, opts("[LSP] Go to definition"))

    map("n", "K", function()
      lspbuf.hover()
    end, opts("[LSP] Hover"))

    map("n", "<leader>la", function()
      lspbuf.code_action()
    end, opts("[LSP] Code action"))

    map("n", "<leader>lR", function()
      lspbuf.references()
    end, opts("[LSP] References"))

    map("n", "<leader>lr", function()
      lspbuf.rename()
    end, opts("[LSP] Rename"))
    map("n", "<leader>li", function()
      lspbuf.implementation({})
    end, opts("[LSP] Implementation"))
    map("n", "<leader>lf", function()
      lspbuf.format()
    end, opts("[LSP] Format"))

    map("i", "<C-h>", function()
      lspbuf.signature_help()
    end, opts("[LSP] Signature help"))

    map("n", "<leader>ld", function()
      lspdiag.open_float()
    end, opts("[LSP] Diagnostics"))

    map("n", "d[", function()
      lspdiag.goto_next()
    end, opts("[LSP] Next diagnostic"))

    map("n", "d]", function()
      lspdiag.goto_prev()
    end, opts("[LSP] Previous diagnostic"))
  end,
})
