return {
  "nvim-neotest/neotest",
  dependencies = {
    "Nsidorenco/neotest-vstest",
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
  },
  opts = function()
    return {
      adapters = {
        require("neotest-vstest")({
          -- Tells neotest to use the coreclr adapter we set up in DAP
          dap_adapter = "coreclr",
        }),
      },
      -- Log level can help if you run into "No tests found" issues
      log_level = vim.log.levels.DEBUG,
    }
  end,
}
