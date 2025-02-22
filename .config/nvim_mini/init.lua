-- Put this at the top of 'init.lua'
local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    -- Uncomment next line to use 'stable' branch
    -- '--branch', 'stable',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
end

vim.g.mapleader = " "

require('mini.base16').setup({
    palette = {
      base00 = '#112641',
      base01 = '#3a475e',
      base02 = '#606b81',
      base03 = '#8691a7',
      base04 = '#d5dc81',
      base05 = '#e2e98f',
      base06 = '#eff69c',
      base07 = '#fcffaa',
      base08 = '#ffcfa0',
      base09 = '#cc7e46',
      base0A = '#46a436',
      base0B = '#9ff895',
      base0C = '#ca6ecf',
      base0D = '#42f7ff',
      base0E = '#ffc4ff',
      base0F = '#00a5c5',
    },
})
require('mini.files').setup()
require('mini.fuzzy').setup()
require('mini.animate').setup()

vim.keymap.set("i", "jk", "<ESC>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader>lc", "<cmd>so % | echo 'Reloaded the current buffer'<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ff", "<cmd>lua require('mini.files').open()<CR>", { noremap = true, silent = true })


vim.cmd('echo "Finished loading config" | redraw')
