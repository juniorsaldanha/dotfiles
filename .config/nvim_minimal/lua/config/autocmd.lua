local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
-- local usercmd = vim.api.nvim_create_user_command

local YankGroup = augroup("YankHighlight", {})
local CustomGroup = augroup("Saldanha", {})

-- Highlight on yank
autocmd("TextYankPost", {
  group = YankGroup,
  callback = function()
    vim.hl.on_yank({ timeout = "150" })
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
