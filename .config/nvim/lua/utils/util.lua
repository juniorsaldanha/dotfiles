local M = {}

-- This will load a module and print an error message if it fails
-- This is useful for optional dependencies that may not be installed
-- IF the require fails, it will print an error message but not throw an error
M.require = function(file)
  local status, _ = pcall(require, file)
  if not status then
    print("Error loading " .. file)
  end
end

-- TODO: This function is not working as expected
M.GetWindows = function()
  -- print(vim.inspect(vim.api.nvim_list_wins()))
  local windows = vim.api.nvim_list_wins()
  -- print all attributes of each window
  for _, window in ipairs(windows) do
    print(vim.inspect(vim.api.nvim_win_get_config(window)))
  end
end

return M
