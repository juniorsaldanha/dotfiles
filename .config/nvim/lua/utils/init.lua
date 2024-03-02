local M = {}

function M.set_keymap(mode, key, action, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, key, action, options)
end

function M.set_keymaps(keymaps)
  for _, keymap in ipairs(keymaps) do
    if #keymap < 4 then
      keymap[4] = nil
    end
    M.set_keymap(keymap[1], keymap[2], keymap[3], keymap[4])
  end
end

return M
