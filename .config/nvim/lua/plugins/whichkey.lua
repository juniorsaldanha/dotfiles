return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    plugins = { spelling = true },
    defaults = {
      mode = { "n", "v" },
      ["<leader>b"] = { name = "[B]uffer" },
      ["<leader>c"] = { name = "[C]onform" },
      ["<leader>l"] = { name = "[L]SP", _ = "which_key_ignore" },
      ["<leader>d"] = { name = "[D]AP", _ = "which_key_ignore" },
      ["<leader>ds"] = { name = "[D]AP [S]teps", _ = "which_key_ignore" },
      ["<leader>dg"] = { name = "[D]AP [G]olang Test", _ = "which_key_ignore" },
      ["<leader>f"] = { name = "[F]ind" },
      ["<leader>n"] = { name = "[N]oice" },
      ["<leader>ft"] = { name = "[T]odo" },
      ["<leader>h"] = { name = "[H]arpoon" },
      ["<leader>g"] = { name = "[G]it" },
      ["<leader>ga"] = { name = "[G]it-[A]ctions" },
      ["<leader>gf"] = { name = "[G]it-[F]ugitive" },
      ["<leader>s"] = { name = "[S]earch" },
      ["<leader>t"] = { name = "[T]odo" },
      ["<leader>o"] = { name = "[O]il" },
      ["<leader>u"] = { _ = "which_key_ignore" },
      ["<leader>x"] = { name = "[X] Diagnostics" },
      ["<leader>z"] = { name = "[Z] Zen" },
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    -- local presets = require("which-key.plugins.presets")
    wk.setup(opts)
    wk.register(opts.defaults)
  end,
}
