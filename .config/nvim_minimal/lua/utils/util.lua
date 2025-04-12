local M = {}

-- This will load a module and print an error message if it fails
-- This is useful for optional dependencies that may not be installed
-- IF the require fails, it will print an error message
M.require = function(file)
	local status, _ = pcall(require, file)
	if not status then
		vim.notify("Error loading file: " .. file, vim.log.levels.WARN, {
			title = "Utils Error Loading File",
		})
	end
end

-- TODO: This function is not working as expected
-- This function will be implemented later for internal workspace purposes
M.GetWindows = function()
	-- print(vim.inspect(vim.api.nvim_list_wins()))
	-- local windows = vim.api.nvim_list_wins()
	local windows = vim.api.nvim_tabpage_list_wins(0)
	-- print all attributes of each window
	for _, window in ipairs(windows) do
		-- print(vim.inspect(vim.api.nvim_win_get_config(window)))

		local bufid = vim.api.nvim_win_get_buf(window)
		-- print(vim.inspect(vim.api.nvim_buf_get_name(bufid)))
		print("buftype" .. vim.inspect(vim.api.nvim_buf_get_option(bufid, "buftype")))
		print("filetype" .. vim.inspect(vim.api.nvim_buf_get_option(bufid, "filetype")))
		-- local actual_opt = vim.api.nvim_win_get_option(window, opt_key)
		-- local has_value = vim.tbl_contains(opt_values, actual_opt)
	end
end

return M
