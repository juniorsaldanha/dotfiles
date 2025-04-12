local map = vim.keymap.set

local opts = function(desc)
  return { desc = desc, noremap = true, silent = true }
end

-- General keymaps
map("n", "<esc>", "<cmd>nohlsearch<cr>", opts("Clear Search Highlight"))
map("i", "jk", "<esc>")

-- Search and Replace on whole buffer
map("n", "<leader>sr", ":%s//g<left><left>", opts("[S]earch and [R]eplace"))
