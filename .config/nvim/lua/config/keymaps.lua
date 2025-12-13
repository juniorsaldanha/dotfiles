--[[
  General Keymaps
  Plugin-specific keymaps are in their respective plugin files for easy customization.
]]

local map = vim.keymap.set

-- Helper for options
local function opts(desc)
    return { desc = desc, noremap = true, silent = true }
end

-- ============================================================================
-- ESCAPE
-- ============================================================================
map("i", "jk", "<Esc>", opts("Exit insert mode"))
map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts("Clear search highlight"))

-- ============================================================================
-- BETTER MOVEMENT
-- ============================================================================
map("n", "j", "gj", opts("Move down (wrapped lines)"))
map("n", "k", "gk", opts("Move up (wrapped lines)"))
map("n", "<C-d>", "<C-d>zz", opts("Scroll down and center"))
map("n", "<C-u>", "<C-u>zz", opts("Scroll up and center"))
map("n", "n", "nzzzv", opts("Next search result and center"))
map("n", "N", "Nzzzv", opts("Previous search result and center"))

-- ============================================================================
-- WINDOW NAVIGATION
-- ============================================================================
map("n", "<C-h>", "<C-w>h", opts("Go to left window"))
map("n", "<C-j>", "<C-w>j", opts("Go to lower window"))
map("n", "<C-k>", "<C-w>k", opts("Go to upper window"))
map("n", "<C-l>", "<C-w>l", opts("Go to right window"))

-- ============================================================================
-- WINDOW RESIZE
-- ============================================================================
map("n", "<C-Up>", "<cmd>resize +2<CR>", opts("Increase window height"))
map("n", "<C-Down>", "<cmd>resize -2<CR>", opts("Decrease window height"))
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", opts("Decrease window width"))
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", opts("Increase window width"))

-- ============================================================================
-- BUFFER NAVIGATION
-- ============================================================================
map("n", "<S-h>", "<cmd>bprevious<CR>", opts("Previous buffer"))
map("n", "<S-l>", "<cmd>bnext<CR>", opts("Next buffer"))
map("n", "<leader>bd", "<cmd>bdelete<CR>", opts("Delete buffer"))

-- ============================================================================
-- VISUAL MODE
-- ============================================================================
map("v", "<", "<gv", opts("Indent left and reselect"))
map("v", ">", ">gv", opts("Indent right and reselect"))
map("v", "J", ":m '>+1<CR>gv=gv", opts("Move selection down"))
map("v", "K", ":m '<-2<CR>gv=gv", opts("Move selection up"))

-- ============================================================================
-- SEARCH AND REPLACE
-- ============================================================================
map("n", "<leader>sr", ":%s//g<Left><Left>", opts("Search and replace"))
map("v", "<leader>sr", ":s//g<Left><Left>", opts("Search and replace in selection"))

-- ============================================================================
-- QUICKFIX
-- ============================================================================
map("n", "<leader>qo", "<cmd>copen<CR>", opts("Open quickfix"))
map("n", "<leader>qc", "<cmd>cclose<CR>", opts("Close quickfix"))
map("n", "]q", "<cmd>cnext<CR>zz", opts("Next quickfix item"))
map("n", "[q", "<cmd>cprev<CR>zz", opts("Previous quickfix item"))

-- ============================================================================
-- MISC
-- ============================================================================
map("n", "<leader>w", "<cmd>w<CR>", opts("Save file"))
map("n", "<leader>q", "<cmd>q<CR>", opts("Quit"))
map("n", "x", '"_x', opts("Delete char without yank"))
map("n", "<leader>Y", '"+Y', opts("Yank line to system clipboard"))
map("v", "<leader>y", '"+y', opts("Yank to system clipboard"))
map("n", "<leader>p", '"+p', opts("Paste from system clipboard"))
