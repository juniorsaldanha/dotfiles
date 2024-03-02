return {
  "christoomey/vim-tmux-navigator",
  event = "VimEnter",
  config = function()
    local k = vim.keymap
    local opts_desc = function(desc)
      return { desc = desc, noremap = true, silent = true }
    end
    k.set(
      "n",
      "<C-h>",
      "<cmd>TmuxNavigateLeft<cr>",
      opts_desc("Go to left pane")
    )
    k.set(
      "n",
      "<C-l>",
      "<cmd>TmuxNavigateRight<cr>",
      opts_desc("Go to right pane")
    )
    k.set(
      "n",
      "<C-j>",
      "<cmd>TmuxNavigateDown<cr>",
      opts_desc("Go to down pane")
    )
    k.set("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", opts_desc("Go to up pane"))
  end,
}
