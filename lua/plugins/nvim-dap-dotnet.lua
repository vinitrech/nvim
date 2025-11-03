-- lua/configs/nvim-dap-dotnet.lua

local Path = require("plenary.path")
local M = {}

-- Normalize Windows paths to use forward slashes
local function normalize_path(path)
  return path:gsub("\\", "/")
end

-- Find the root directory of a .NET project by searching for .csproj files
function M.find_project_root_by_csproj(start_path)
  local path = Path:new(start_path)

  while true do
    local check_path = normalize_path(path:absolute())
    print("Checking for .csproj in:", check_path) -- debug print
    local csproj_files = vim.fn.glob(check_path .. "/*.csproj", false, true)
    if #csproj_files > 0 then
      return path:absolute()
    end

    local parent = path:parent()
    if parent:absolute() == path:absolute() then
      return nil
    end
    path = parent
  end
end

-- Find the highest version of the netX.Y folder within a given path
function M.get_highest_net_folder(bin_path)
  local dirs = vim.fn.glob(normalize_path(bin_path) .. "/net*", false, true)
  if #dirs == 0 then
    error("No netX.Y folders found in " .. bin_path)
  end
  table.sort(dirs, function(a, b)
    local ver_a = tonumber(a:match("net(%d+)%.%d+"))
    local ver_b = tonumber(b:match("net(%d+)%.%d+"))
    return ver_a > ver_b
  end)
  return dirs[1]
end

-- Build the full path to the .dll file for debugging
function M.build_dll_path()
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir = vim.fn.fnamemodify(current_file, ":p:h")

  -- Try to find project root automatically
  local project_root = M.find_project_root_by_csproj(current_dir)
  if not project_root then
    project_root = vim.fn.input("Could not find .csproj automatically. Enter project root: ", current_dir, "dir")
  end

  local csproj_files = vim.fn.glob(normalize_path(project_root) .. "/*.csproj", false, true)
  local project_name
  if #csproj_files > 0 then
    project_name = vim.fn.fnamemodify(csproj_files[1], ":t:r")
  else
    project_name = vim.fn.input("Enter project name (DLL name without extension): ")
  end

  -- Determine Debug vs Release automatically
  local build_type
  if vim.fn.isdirectory(project_root .. "/bin/Debug") == 1 then
    build_type = "Debug"
  elseif vim.fn.isdirectory(project_root .. "/bin/Release") == 1 then
    build_type = "Release"
  else
    build_type = vim.fn.input("Could not find Debug/Release folder. Enter build type: ", "Debug")
  end

  local bin_path = project_root .. "/bin/" .. build_type
  local highest_net_folder
  local ok, folder = pcall(M.get_highest_net_folder, bin_path)
  if ok then
    highest_net_folder = folder
  else
    return vim.fn.input("Could not detect DLL automatically. Enter full path to DLL: ", "", "file")
  end

  local dll_path = highest_net_folder .. "/" .. project_name .. ".dll"
  print("Launching: " .. dll_path)
  return dll_path
end

-- Lazy.nvim plugin table
return {
  "mfussenegger/nvim-dap",
  ft = { "cs" },
  config = function()
    local dap = require("dap")

    -- Determine correct netcoredbg path for platform
    local mason_path = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg"
    if vim.loop.os_uname().sysname == "Windows_NT" then
      mason_path = mason_path .. ".exe"
    end

    local netcoredbg_adapter = {
      type = "executable",
      command = mason_path,
      args = { "--interpreter=vscode" },
    }

    -- Adapters
    dap.adapters.netcoredbg = netcoredbg_adapter
    dap.adapters.coreclr = netcoredbg_adapter

    -- Launch configuration for C#
    dap.configurations.cs = {
      {
        type = "coreclr",
        name = "Launch .NET DLL",
        request = "launch",
        program = function()
          return M.build_dll_path()
        end,
      },
    }
  end,
}

