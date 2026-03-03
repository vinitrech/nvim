return {
  "folke/tokyonight.nvim",
  opts = {
    style = "storm",
    transparent = true,
    terminal_colors = true,

    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },

    -- Match Ghostty background exactly
    on_colors = function(colors)
      colors.bg = "#071a26" -- exact terminal background
      colors.bg_dark = "#061520"
      colors.bg_float = "#0b2230"
      colors.border = "#123247"
    end,

    on_highlights = function(hl, c)
      local soft = "#0a202c" -- blended glass color (near terminal bg)

      --------------------------------------------------
      -- DIAGNOSTIC VIRTUAL TEXT (the popup labels)
      --------------------------------------------------
      hl.DiagnosticVirtualTextError = { fg = c.error, bg = soft }
      hl.DiagnosticVirtualTextWarn = { fg = c.warning, bg = soft }
      hl.DiagnosticVirtualTextInfo = { fg = c.info, bg = soft }
      hl.DiagnosticVirtualTextHint = { fg = "#4fd1c5", bg = soft }

      --------------------------------------------------
      -- NEW Neovim 0.10+ inline hints (important!)
      --------------------------------------------------
      hl.LspInlayHint = {
        fg = "#5a7d8c",
        bg = "none",
        italic = true,
      }

      -- Fully transparent main areas
      hl.Normal = { bg = "none" }
      hl.NormalFloat = { bg = "none" }
      hl.FloatBorder = { fg = "#123247", bg = "none" }

      -- Cursor line fully transparent
      hl.CursorLine = { bg = "none" }

      -- Make active line number teal (matches your terminal accent)
      hl.CursorLineNr = { fg = "#4fd1c5", bold = true }

      -- Dim inactive line numbers
      hl.LineNr = { fg = "#1c3a4a" }

      -- Slightly visible visual selection
      hl.Visual = { bg = "#123247" }

      -- Telescope / popup blending
      hl.Pmenu = { bg = "none" }
      hl.PmenuSel = { bg = "#123247", fg = "#4fd1c5" }

      -- Make comments slightly more cinematic
      hl.Comment = { fg = "#3a596b", italic = true }
    end,
  },

  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd.colorscheme("tokyonight")
  end,
}
