return {
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")

      -- 1. Configure the Adapter
      dap.adapters.coreclr = {
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg",
        args = { "--interpreter=vscode" },
      }

      -- 2. Configure C# Launch Settings
      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "launch - netcoredbg",
          request = "launch",
          program = function()
            -- Automatically find the DLL or ask the user
            local path = vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
            return path
          end,
        },
      }
    end,
  },
}
