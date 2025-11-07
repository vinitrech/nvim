return {
  "folke/tokyonight.nvim",
  opts = {
    style = "night", -- or "storm" or "light"
    transparent = true,
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd.colorscheme("tokyonight")
  end,
}
