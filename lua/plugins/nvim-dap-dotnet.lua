-- lua/plugins/nvim-dap-dotnet.lua
return {
  "mfussenegger/nvim-dap",
  lazy = true,
  config = function()
    local dap = require("dap")
    local Path = require("plenary.path")

    -- Use netcoredbg from PATH
    local netcoredbg_adapter = {
      type = "executable",
      command = "netcoredbg",
      args = { "--interpreter=vscode" },
    }

    dap.adapters.coreclr = netcoredbg_adapter
    dap.adapters.netcoredbg = netcoredbg_adapter

    -- Fixed cross-platform find_csproj
    local function find_csproj(startpath)
      local p = Path:new(startpath)
      while p do
        local files = vim.fn.glob(p:absolute() .. "/*.csproj", false, true)
        if #files > 0 then
          return files[1]
        end

        local parent = p:parent()
        if parent:absolute() == p:absolute() then
          return nil
        end
        p = parent
      end
    end

    -- DAP configuration for C#
    dap.configurations.cs = {
      {
        type = "coreclr",
        name = "Launch - Current File",
        request = "launch",
        program = function()
          local current_file = vim.api.nvim_buf_get_name(0)
          local project_file = find_csproj(vim.fn.fnamemodify(current_file, ":p:h"))
          if not project_file then
            error("Could not find project root (no .csproj found)")
          end

          local dll_name = vim.fn.fnamemodify(project_file, ":t:r") .. ".dll"
          local dll_path = vim.fn.fnamemodify(project_file, ":p:h") .. "/bin/Debug/net8.0/" .. dll_name

          if not vim.loop.fs_stat(dll_path) then
            error("DLL not found: " .. dll_path .. "\nMake sure the project is built.")
          end

          return dll_path
        end,
        cwd = "${workspaceFolder}",
      },
    }

    -- Optional: DAP UI
    local ok_ui, dapui = pcall(require, "dapui")
    if ok_ui then
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end

    -- Optional: Virtual text
    local ok_vt, vt = pcall(require, "nvim-dap-virtual-text")
    if ok_vt then
      vt.setup {
        commented = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = true,
        show_stop_reason = true,
        virt_text_win_col = nil,
      }
    end
  end,
}
