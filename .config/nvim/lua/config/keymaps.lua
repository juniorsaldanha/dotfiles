local k = vim.keymap

-- Set space as the leader key
vim.g.mapleader = " "

-- jk to escape
k.set("i", "jk", "<esc>", { desc = "Escape it from insert mode", noremap = true, silent = true })

-- <S-h/l> to go to the beginning/end of the line (non white-space)
k.set("n", "<S-h>", "^", { desc = "Go to first char on line", noremap = true, silent = true })
k.set("n", "<S-l>", "$", { desc = "Go to last char on line", noremap = true, silent = true })

-- <C-h/l> to move to the window to the left/right
k.set("n", "<C-h>", "<C-w>h", { desc = "Go to left pane", noremap = true, silent = true })
k.set("n", "<C-l>", "<C-w>l", { desc = "Go to right pane", noremap = true, silent = true })

-- <C-j/k> to move to the windows to the up/down
k.set("n", "<C-j>", "<C-w>j", { desc = "Go to down pane", noremap = true, silent = true })
k.set("n", "<C-k>", "<C-w>k", { desc = "Go to up pane", noremap = true, silent = true })

-- Move selected line / block of text in visual mode
k.set("x", "J", ":move '>+1<CR>gv-gv", { noremap = true, silent = true })
k.set("x", "K", ":move '<-2<CR>gv-gv", { noremap = true, silent = true })

-- Close  with <leader>bd
k.set(
  "n",
  "<leader>bd",
  ":bd<CR>",
  { desc = "Close current ", noremap = true, silent = true }
)
-- Delete  FORCE with <leader>bD
k.set(
  "n",
  "<leader>bD",
  ":bd!<CR>",
  { desc = "Close current  FORCED", noremap = true, silent = true }
)
-- Close all s except the current one with <leader>ba
k.set("n", "<leader>ba", ":bufdo bd %<CR>", {
  desc = "Close all s except the current one",
  noremap = true,
  silent = true,
})

k.set(
  "n",
  "<leader>sc",
  ":noh<CR>",
  { desc = "Clear search highlights", noremap = true, silent = true }
)
 
k.set(
  "n",
  "<leader>sr",
  ":%s//g<Left><Left>",
  { desc = "Search and replace", noremap = true, silent = true }
)

k.set(
  "n",
  "<leader>ss",
  ":set spell!<CR>",
  { desc = "Toggle spell check", noremap = true, silent = true }
)
