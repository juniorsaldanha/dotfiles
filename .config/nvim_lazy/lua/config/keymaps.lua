-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
local optsWithDesc = function(desc, noremap, silent)
  return { desc = desc, noremap = noremap, silent = silent }
end

keymap.set("i", "jk", "<esc>", optsWithDesc("Exit insert mode <ESC>", true, true))
-- keymap.set("n", ";", ":", optsWithDesc("Enter command mode", true, true))
-- keymap.set("n", "<C-k>", "<cmd>noh<cr>", opts)
keymap.set("n", "<S-h>", "^", optsWithDesc("Go to first non-whitespace in the line", true, true))
keymap.set("n", "<S-l>", "g_", optsWithDesc("Go to last non-whitespace in the line", true, true))

-- Remove word under cursorline
-- keymap.set("n", "dw", "diw", optsWithDesc("Remove word under cursorline", true, true))

-- Resize panels with j,k,l,h instead of <C-w>...
keymap.set("n", "<C-w>l", "<cmd>vertical resize +5<cr>", optsWithDesc("Increase width", false, true))
keymap.set("n", "<C-w>h", "<cmd>vertical resize -5<cr>", optsWithDesc("Decrease width", false, true))
keymap.set("n", "<C-w>k", "<cmd>horizontal resize +5<cr>", optsWithDesc("Increase hight", false, true))
keymap.set("n", "<C-w>j", "<cmd>horizontal resize -5<cr>", optsWithDesc("Decrease height", false, true))

-- Bufers keymaps
keymap.set("n", "<tab>", "<cmd>BufferLineCycleNext<cr>", optsWithDesc("Next buffer", true, true))
keymap.set("n", "<S-tab>", "<cmd>BufferLineCyclePrev<cr>", optsWithDesc("Previous buffer", true, true))
keymap.set("n", "te", "<cmd>tabedit<cr>", optsWithDesc("New tab", true, true))

-- TmuxNavigate keymaps
keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", optsWithDesc("Go to left pane", true, true))
keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", optsWithDesc("Go to down pane", true, true))
keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", optsWithDesc("Go to up pane", true, true))
keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", optsWithDesc("Go to right pane", true, true))
keymap.set("n", "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", optsWithDesc("Go to previous pane", true, true))
