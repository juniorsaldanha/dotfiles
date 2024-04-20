return {
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      {
        "<leader>du",
        "<cmd>lua require('dapui').toggle()<cr>",
        desc = "[DAP] UI Toggle",
      },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup({
        force_buffers = true,
        icons = {
          current_frame = "",
          expanded = "▾",
          collapsed = "▸",
        },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        floating = {
          max_height = 0.5,
          max_width = 0.5,
          border = "single",
          mappings = {
            ["close"] = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 },
        element_mappings = {
          watches = {
            remove = "d",
          },
        },
        expand_lines = true,
        layouts = {
          {
            -- You can change the order of elements in the sidebar
            elements = {
              -- Provide IDs as strings or tables with "id" and "size" keys
              {
                id = "scopes",
                size = 0.25, -- Can be float or integer > 1
              },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 60,
            position = "left", -- Can be "left" or "right"
          },
          {
            elements = {
              "repl",
              "console",
            },
            size = 10,
            position = "bottom", -- Can be "bottom" or "top"
          },
        },
        ---@diagnostic disable-next-line: missing-fields
        controls = {
          enable = true,
          ---@diagnostic disable-next-line: missing-fields
          icons = {
            expanded = "▾",
            collapsed = "▸",
            circular = "↺",
          },
          floating = {
            enabled = true,
            border = "single",
            focus = false,
          },
        },
        render = {
          indent = 2,
        },
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<leader>dt",
        "<cmd>lua require('dap').toggle_breakpoint()<cr>",
        desc = "[DAP] Breakpoint [T]oggle",
      },
      {
        "<leader>dc",
        "<cmd>lua require('dap').continue()<cr>",
        desc = "[DAP] [C]ontinue/Start",
      },
      {
        "<leader>dsi",
        "<cmd>lua require('dap').step_into()<cr>",
        desc = "[DAP] [S]tep [I]nto",
      },
      {
        "<leader>dso",
        "<cmd>lua require('dap').step_over()<cr>",
        desc = "[DAP] [S]tep [O]ver",
      },
      {
        "<leader>dsO",
        "<cmd>lua require('dap').step_out()<cr>",
        desc = "[DAP] [S]tep [O]ut",
      },
      {
        "<leader>dr",
        "<cmd>lua require('dap').repl.toggle()<cr>",
        desc = "[DAP] [R]EPL Toggle",
      },
      {
        "<leader>dd",
        "<cmd>lua require('dap').terminate()<cr>",
        desc = "[DAP] [D]isconnect/Terminate",
      },
      {
        "<leader>dl",
        "<cmd>lua require('dap').run_last()<cr>",
        desc = "[DAP] Run [L]ast",
      },
      {
        "<leader>dh",
        "<cmd>lua require('dap.ui.widgets').hover()<cr>",
        desc = "[DAP] [H]over",
      },
      {
        "<leader>dp",
        "<cmd>lua require('dap.ui.widgets').preview()<cr>",
        desc = "[DAP] [P]review",
      },
    },
    config = function()
      local dap = require("dap")
      dap.listeners.before["event_initialized"]["dapui_events"] = function()
        vim.print("event_initialized, opening dapui")
        require("dapui").open()
      end

      dap.listeners.before["event_terminated"]["dapui_events"] = function()
        vim.print("event_terminated, closing dapui")
        require("dapui").close()
      end
    end,
  },
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = { "mfussenegger/nvim-dap" },
    keys = {
      {
        "<leader>dgt",
        function()
          require("dap-go").debug_test()
        end,
        desc = "[DAP] [G]o [T]est",
      },
      {
        "<leader>dgl",
        function()
          require("dap-go").debug_last_test()
        end,
        desc = "[DAP] [G]o [L]ast",
      },
    },
    config = function()
      require("dap-go").setup()
    end,
  },
}
