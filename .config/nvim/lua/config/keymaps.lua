local k = vim.keymap

-- Set space as the leader key
vim.g.mapleader = " "

-- jk to escape
k.set("i", "jk", "<esc>", { noremap = true, silent = true })

-- <S-h/l> to go to the beginning/end of the line (non white-space)
k.set("n", "<S-h>", "^", { noremap = true, silent = true })
k.set("n", "<S-l>", "$", { noremap = true, silent = true })

-- <C-h/l> to move to the window to the left/right
k.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
k.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

-- <C-j/k> to move to the windows to the up/down
k.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
k.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })

-- Move selected line / block of text in visual mode
k.set("x", "K", ":move '<-2<CR>gv-gv", { noremap = true, silent = true })
k.set("x", "J", ":move '>+1<CR>gv-gv", { noremap = true, silent = true })

-- Close buffer with <leader>bd
k.set(
  "n",
  "<leader>bd",
  "<cmd>bd<CR>",
  { desc = "Close current buffer", noremap = true, silent = true }
)
-- Delete buffer FORCE with <leader>bD
k.set(
  "n",
  "<leader>bD",
  "<cmd>bd!<CR>",
  { desc = "Close current buffer", noremap = true, silent = true }
)
-- Close all buffers except the current one with <leader>ba
k.set("n", "<leader>ba", "<cmd>bufdo bd %<CR>", {
  desc = "Close all buffers except the current one",
  noremap = true,
  silent = true,
})

-- Windows resizing with <C-w> and h/j/k/l repetly and Descriptions to WhichKey
k.set(
  "n",
  "<C-w-h>",
  "<C-w><",
  { desc = "Resize window left", noremap = true, silent = true }
)
k.set(
  "n",
  "<C-w>j",
  "<C-w>-",
  { desc = "Resize window down", noremap = true, silent = true }
)
k.set(
  "n",
  "<C-w>k",
  "<C-w>+",
  { desc = "Resize window up", noremap = true, silent = true }
)
k.set(
  "n",
  "<C-w>l",
  "<C-w>>",
  { desc = "Resize window right", noremap = true, silent = true }
)
