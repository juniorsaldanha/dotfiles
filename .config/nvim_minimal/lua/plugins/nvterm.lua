return {
  "NvChad/nvterm",
  config = function()
    require("nvterm").setup({
      terminals = {
        type_opts = {
          float = {
            relative = "editor",
            row = 0.1,
            col = 0.1,
            width = 0.8,
            height = 0.8,
            border = "single",
          },
        },
      },
    })

    vim.keymap.set({ "n", "t" }, "<c-_>", function()
      require("nvterm.terminal").toggle("float")
    end, {
      desc = "Toggle Terminal Floating",
      noremap = true,
      silent = true,
    })
  end,
}
