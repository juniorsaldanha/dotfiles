return {
	"nvim-tree/nvim-tree.lua",
	version = "1.0",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("nvim-tree").setup({
			sort = {
				sorter = "case_sensitive",
			},
			view = {
				width = 40,
				side = "left",
			},
			renderer = {
				indent_markers = {
					enable = true,
				},
			},
			filters = {
				dotfiles = true,
			},
		})

		vim.keymap.set(
			"n",
			"<leader>e",
			"<cmd>NvimTreeToggle<CR>",
			{ desc = "Nvim Tree Toggle", noremap = true, silent = true }
		)
	end,
}
