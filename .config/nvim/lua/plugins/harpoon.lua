return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    local map = vim.keymap.set
    local opts = function(desc)
      return { desc = desc }
    end
    map("n", "<leader>ha", function()
      harpoon:list():add()
    end, opts("Add buffer to harpoon list"))
    map("n", "<c-e>", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end)

    map("n", "<C-f>", function()
      harpoon:list():select(1)
    end)
    map("n", "<C-g>", function()
      harpoon:list():select(2)
    end)
    map("n", "<C-s>", function()
      harpoon:list():select(3)
    end)

    -- Toggle previous & next buffers stored within Harpoon list
    map("n", "<C-p>", function()
      harpoon:list():prev()
    end)
    map("n", "<C-n>", function()
      harpoon:list():next()
    end)
  end,
}
