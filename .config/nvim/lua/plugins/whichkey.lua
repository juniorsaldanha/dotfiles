return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    plugins = { spelling = true },
    defaults = {
      mode = { "n", "v" },
      ["<leader>b"] = { name = "[B]uffer" },
      ["<leader>c"] = { name = "[C]ode" },
      ["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
      ["<leader>f"] = { name = "[F]ind" },
      ["<leader>n"] = { name = "[N]oice" },
      ["<leader>ft"] = { name = "[T]odo" },
      ["<leader>h"] = { name = "[H]arpoon" },
      ["<leader>g"] = { name = "[G]it" },
      ["<leader>ga"] = { name = "[G]it-[A]ctions" },
      ["<leader>s"] = { name = "[S]earch" },
      ["<leader>o"] = { name = "[O]il" },
      ["<leader>z"] = { name = "+others" },
      ["<leader>u"] = { _ = "which_key_ignore" },
      -- ["<leader>x"] = { name = "+dagnostics/quickfix" },
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    -- local presets = require("which-key.plugins.presets")
    wk.setup(opts)
    wk.register(opts.defaults)
  end,
}
