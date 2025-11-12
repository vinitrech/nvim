return {
  {
    "seblyng/roslyn.nvim",
    ft = { "cs", "vb" },
    opts = {}, -- leave it empty or tweak small options
    config = function(_, opts)
      require("roslyn").setup(opts)
    end,
  },
}
