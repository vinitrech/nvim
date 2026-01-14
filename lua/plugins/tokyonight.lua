return {
  "folke/tokyonight.nvim",
  opts = {
    style = "moon", -- or "storm" or "light"
    transparent = true,
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
    on_highlights = function(hl, c)
      -- Make cursor line background completely transparent
      hl.CursorLine = { bg = "none" }
      -- Keep the current line number bright so you still see your position
      hl.CursorLineNr = { fg = c.warning, bold = true }
    end,
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd.colorscheme("tokyonight")
  end,
}
