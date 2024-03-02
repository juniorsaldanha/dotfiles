return {
  "folke/todo-comments.nvim",
  lazy = false,
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader>ftt",
      "<cmd>TodoTelescope<cr>",
      desc = "Open the todo list",
    },
    {
      "<leader>ftf",
      "<cmd>TodoTelescope keywords=FIX,WARN,WARNING<cr>",
    },
    {
      "<leader>ftd",
      "<cmd>TodoTelescope keywords=TODO,HACK,NOTE<cr>",
    },
    {
      "<leader>fti",
      "<cmd>TodoTelescope keywords=INFO<cr>",
    },
    {
      "<leader>ftc",
      "<cmd>TodoTelescope keywords=FIXME,BUG,ERROR<cr>",
    },
    {
      "]t",
      function()
        require("todo-comments").jump_next()
      end
    },
    {
      "[t",
      function()
        require("todo-comments").jump_prev()
      end
    },
    {
      "}t",
      function()
        require("todo-comments").jump_next({ keywords = { "ERROR", "WARNING" } })
      end
    },
    {
      "{t",
      function()
        require("todo-comments").jump_prev({ keywords = { "ERROR", "WARNING" } })
      end
    },
  },
  opts = {
    search = {
      command = "rg",
      args = {
        "--hidden",
        "--smart-case",
        "--vimgrep",
        "--follow",
        "--color=never",
      },
    },
  },
}
