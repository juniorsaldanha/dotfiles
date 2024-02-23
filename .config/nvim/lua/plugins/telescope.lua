return {
  "nvim-telescope/telescope.nvim",
  version = false,
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      enabled = vim.fn.executable("make") == 1,
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },
  keys = {
    {
      "<leader>ff",
      "<cmd>lua require('telescope.builtin').find_files()<cr>",
      desc = "Find files",
    },
    {
      "<leader>fg",
      "<cmd>lua require('telescope.builtin').live_grep()<cr>",
      desc = "Find in files",
    },
    {
      "<leader>fb",
      "<cmd>lua require('telescope.builtin').buffers()<cr>",
      desc = "Find buffers",
    },
    {
      "<leader>fh",
      "<cmd>lua require('telescope.builtin').help_tags()<cr>",
      desc = "Find help tags",
    },
  },
  opts = {
    defaults = {
      prompt_position = "top",
      sorting_strategy = "ascending",
    },
  },
  config = function()
    require("telescope").setup({})
  end,
}
