local function reset_logo_hls()
  -- This is a workaround for the issue where the colors of the logo are not updated when the colorscheme changes
  local blue = "#61afef"
  local green = "#98c379"
  local logo_hls = {
    { "NeovimDashboardLogo1", { fg = blue } },
    { "NeovimDashboardLogo2", { fg = green, bg = blue } },
    { "NeovimDashboardLogo3", { fg = green } },
  }

  for _, hl in ipairs(logo_hls) do
    local name, opts = unpack(hl)
    vim.api.nvim_set_hl(0, name, opts)
  end
end

local function configure()
  local dashboard = require("alpha.themes.dashboard")
  local startup_time = nil
  local buttons = {
    type = "group",
    val = {
      {
        type = "text",
        val = "Quick links",
        opts = { hl = "SpecialComment", position = "center" },
      },
      { type = "padding", val = 1 },
      dashboard.button("e", "  New file", "<cmd>ene<CR>"),
      dashboard.button("SPC ff", "  Find file"),
      dashboard.button("SPC fg", "  Find in files"),
      dashboard.button("u", "󱐥  Update plugins", "<cmd>Lazy sync<CR>"),
      dashboard.button("t", "  Install language tools", "<cmd>Mason<CR>"),
      dashboard.button("q", "󰩈  Quit", "<cmd>qa<CR>"),
    },
    position = "center",
  }

  dashboard.section.header.val = {

    [[          ▀████▀▄▄              ▄█ ]],
    [[            █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█ ]],
    [[    ▄        █          ▀▀▀▀▄  ▄▀  ]],
    [[   ▄▀ ▀▄      ▀▄              ▀▄▀  ]],
    [[  ▄▀    █     █▀   ▄█▀▄      ▄█    ]],
    [[  ▀▄     ▀▄  █     ▀██▀     ██▄█   ]],
    [[   ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █  ]],
    [[    █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀  ]],
    [[   █   █  █      ▄▄           ▄▀   ]],
  }

  dashboard.section.header.opts.hl = {
    { { "NeovimDashboardLogo1", 6, 8 }, { "NeovimDashboardLogo3", 9, 22 } },
    {
      { "NeovimDashboardLogo1", 6, 8 },
      { "NeovimDashboardLogo2", 9, 11 },
      { "NeovimDashboardLogo3", 12, 24 },
    },
    { { "NeovimDashboardLogo1", 6, 11 }, { "NeovimDashboardLogo3", 12, 26 } },
    { { "NeovimDashboardLogo1", 6, 11 }, { "NeovimDashboardLogo3", 12, 24 } },
    { { "NeovimDashboardLogo1", 6, 11 }, { "NeovimDashboardLogo3", 12, 22 } },
  }
  dashboard.section.buttons = buttons

  dashboard.section.footer.val = function()
    if not startup_time then
      return {}
    end
    return { string.format("Loaded in %.0fms", startup_time) }
  end
  dashboard.section.footer.opts.hl = { { { "YonvimDashboardFooter", 0, 15 } } }

  local augroup = vim.api.nvim_create_augroup("yonvim_alpha", {})

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = augroup,
    callback = function()
      reset_logo_hls()
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    group = augroup,
    pattern = "LazyVimStarted",
    callback = function()
      startup_time = require("lazy").stats().startuptime
      vim.cmd.AlphaRedraw()
    end,
  })

  return dashboard.config
end

return {
  "goolord/alpha-nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("alpha").setup(configure())
  end,
}
