local M = {}

M.require = function(file)
  local status, _ = pcall(require, file)
  if not status then
    print("Error loading " .. file)
  end
end

M.getWindows = function()
  -- print(vim.inspect(vim.api.nvim_list_wins()))
  local windows = vim.api.nvim_list_wins()
  -- print all attributes of each window
  for _, window in ipairs(windows) do
    print(vim.inspect(vim.api.nvim_win_get_config(window)))
  end
end

-- Test
-- vim.keymap.set("n", "<leader>ww", M.getWindows)

return M
