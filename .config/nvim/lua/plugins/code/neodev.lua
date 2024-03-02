return {
  "folke/neodev.nvim",
  lazy = false,
  opts = {
    override = function(root_dir, library)
      if string.find(root_dir, "nvim") then
        library.enabled = true
        library.plugins = true
        vim.notify_once("Neodev ENABLED", vim.log.levels.WARN, { title = "neodev.nvim" })
      else
        vim.notify_once("Neodev DISABLED", vim.log.levels.WARN, { title = "neodev.nvim" })
      end
    end,
  },
}
