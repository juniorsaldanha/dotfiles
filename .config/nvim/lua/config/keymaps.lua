local k = vim.keymap

-- Set space as the leader key
vim.g.mapleader = " "

local opts = { noremap = true, silent = true }
local opts_desc = function(desc)
  return { desc = desc, noremap = true, silent = true }
end

k.set("i", "jk", "<esc>", opts_desc("Escape it from insert mode"))

k.set("n", "<S-h>", "^", opts_desc("Go to first char on line"))
k.set("n", "<S-l>", "$", opts_desc("Go to last char on line"))
k.set("x", "J", ":move '>+1<CR>gv-gv", opts)
k.set("x", "K", ":move '<-2<CR>gv-gv", opts)

k.set("n", "<leader>bd", "<cmd>b#|bd#<CR>", opts_desc("Close buffer"))

k.set("n", "<TAB>", ":BufferLineCycleNext<CR>", opts_desc("Next buffer"))
k.set("n", "<S-TAB>", ":BufferLineCyclePrev<CR>", opts_desc("Previous buffer"))
k.set("n", "<leader>br", ":BufferLineCloseRight<CR>", opts_desc("Close right buffers"))
k.set("n", "<leader>bl", ":BufferLineCloseLeft<CR>", opts_desc("Close left buffers"))
k.set("n", "<leader>bc", ":BufferLineCloseOthers<CR>", opts_desc("Close all buffers but current"))
k.set("n", "<leader>bp", ":BufferLineMovePrev<CR>", opts_desc("Move buffer to previous position"))
k.set("n", "<leader>bn", ":BufferLineMoveNext<CR>", opts_desc("Move buffer to next position"))
k.set("n", "<leader>bp", ":BufferLineTogglePin<CR>", opts_desc("Pin buffer"))

k.set("n", "<leader>sc", ":noh<CR>", opts_desc("Clear search highlights"))

k.set("n", "<leader>sr", ":%s//g<Left><Left>", opts_desc("Search and replace"))

k.set("n", "<leader>ss", ":set spell!<CR>", opts_desc("Toggle spell check"))

-- Reload config with <leader>rc
k.set("n", "<leader>rc", ":luafile %<CR>", { desc = "Reload config", noremap = true, silent = true })

-- LPS Keymaps
k.set("n", "K", ":lua vim.lsp.buf.hover()<cr>", opts_desc("Hover"))
k.set("n", "gd", ":lua require('telescope.builtin').lsp_definitions()<cr>", opts_desc("Go to Definition"))
k.set("n", "gD", ":lua require('telescope.builtin').lsp_declarations()<cr>", opts_desc("Go to Declaration"))
k.set("n", "gr", ":lua require('telescope.builtin').lsp_references()<cr>", opts_desc("Go to References"))
k.set("n", "gi", ":lua require('telescope.builtin').lsp_implementations()<cr>", opts_desc("Go to Implementation"))
k.set("n", "<C-k>", ":lua vim.lsp.buf.signature_help()<cr>", opts_desc("Signature Help"))
k.set("n", "[d", ":lua vim.lsp.diagnostic.goto_prev()<cr>", opts_desc("Go to Previous Diagnostic"))
k.set("n", "]d", ":lua vim.lsp.diagnostic.goto_next()<cr>", opts_desc("Go to Next Diagnostic"))
k.set("n", "<leader>cr", ":lua vim.lsp.buf.rename()<cr>", opts_desc("Rename"))
k.set("n", "<leader>ca", ":lua vim.lsp.buf.code_action()<cr>", opts_desc("Code Action"))
k.set("n", "<leader>cs", ":lua vim.lsp.diagnostic.set_loclist()<cr>", opts_desc("Set Location List"))
