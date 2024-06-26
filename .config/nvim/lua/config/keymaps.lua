local map = vim.keymap.set

local opts = function(desc)
  return { desc = desc, noremap = true, silent = true }
end

-- General keymaps
map("n", "<esc>", "<cmd>nohlsearch<cr>", opts("Clear Search Highlight"))
map("i", "jk", "<esc>")

-- Go To first/last char on line
map("n", "<S-h>", "^", opts("Go first char on line"))
map("n", "<S-l>", "$", opts("Go first char on line"))

-- Buffers
map("n", "<leader>bn", "<cmd>bn<cr>", opts("[B]uffer [N]ext Buffer"))
map("n", "<leader>bp", "<cmd>bp<cr>", opts("[B]uffer [P]revious Buffer"))
map("n", "<leader>bd", "<cmd>bd<cr>", opts("[B]uffer [D]elete Buffer"))
map("n", "<leader>ba", "<cmd>bufdo bd<cr>", opts("[B]uffer Delete [A]ll Buffers"))

-- Search and Replace on whole buffer
map("n", "<leader>sr", ":%s//g<left><left>", opts("[S]earch and [R]eplace"))
