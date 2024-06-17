return {
  "christoomey/vim-tmux-navigator",
  lazy = false,
  keys = {
    { "<c-h>", "<cmd>TmuxNavigateLeft<cr>" },
  },
  config = function()
    local map = vim.keymap.set
    local unmap = vim.keymap.del
    local opts = function(desc)
      return { noremap = true, silent = true, desc = desc }
    end
    unmap("n", "<c-h>")
    unmap("n", "<c-l>")
    unmap("n", "<c-j>")
    unmap("n", "<c-k>")
    -- map("n", "<c-h>", "<cmd>TmuxNavigateLeft<cr>", opts("Go Left"))
    map("n", "<c-h>", function() print("asdf") end, opts("Go Left"))
    map("n", "<c-l>", "<cmd>TmuxNavigateRight<cr>", opts("Go Right"))
    map("n", "<c-j>", "<cmd>TmuxNavigateDown<cr>", opts("Go Down"))
    map("n", "<c-k>", "<cmd>TmuxNavigateUp<cr>", opts("Go Up"))
    vim.notify("Configured tmux nav", vim.log.levels.INFO)
  end
}
