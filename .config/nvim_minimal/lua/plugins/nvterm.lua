local map = vim.keymap.set
local opts = function(desc)
  return { noremap = true, silent = true, desc = desc }
end
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
          horizontal = { location = "rightbelow", split_ratio = .3, },
          vertical = { location = "rightbelow", split_ratio = .5 },
        },
      },
    })

    map({ "n", "t" }, "<c-_>", function()
      require("nvterm.terminal").toggle("float")
    end, opts("Toggle Terminal Floating"))
    map({ "n", "t" }, "<leader>t", function()
      require("nvterm.terminal").toggle("horizontal")
    end, opts("Toggle Terminal Horizontal"))
    map({ "n", "t" }, "<leader>v", function()
      require("nvterm.terminal").toggle("vertical")
    end, opts("Toggle Terminal Vertical"))
  end,
}
