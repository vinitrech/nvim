return {
  {
    "seblyng/roslyn.nvim",
    enabled = true,
    ft = "cs", -- Filetype for C#
    config = function()
      -- Optional: Add on_attach function here for custom keymaps or actions
      require("roslyn").setup()
    end,
  },
}
