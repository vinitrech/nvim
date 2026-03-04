return {
  {
    "oxfist/night-owl.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- 1. Setup the theme options
      require("night-owl").setup({
        transparent_background = true,
      })

      -- 2. Define a function to force transparency across the board
      local function transparent_extra()
        local groups = {
          -- Standard UI & Floating Windows
          "Normal",
          "NormalNC",
          "NormalFloat",
          "FloatBorder",
          "FloatTitle",
          "FloatFooter",
          "SignColumn",
          "EndOfBuffer",
          "MsgArea",
          "Pmenu",
          "PmenuSel",

          -- Snacks.nvim Picker
          "SnacksPicker",
          "SnacksPickerList",
          "SnacksPickerListBorder",
          "SnacksPickerListFooter",
          "SnacksPickerListTitle",
          "SnacksPickerNormal",

          -- Neogit Specific Groups (Fixes the left panels in your screenshot)
          "NeogitNormal",
          "NeogitStatusNormal",
          "NeogitSectionHeader",
          "NeogitSectionHeaderCursor",
          "NeogitHunkHeader",
          "NeogitHunkHeaderCursor",
          "NeogitDiffContextHighlight",
          "NeogitDiffAddHighlight",
          "NeogitDiffDeleteHighlight",

          -- Sidebars & General UI
          "NeoTreeNormal",
          "NeoTreeNormalNC",
          "WinSeparator",
          "CursorLine",
        }

        for _, group in ipairs(groups) do
          vim.api.nvim_set_hl(0, group, { bg = "none", ctermbg = "none" })
        end
      end
      -- 3. Run it once immediately
      vim.cmd.colorscheme("night-owl")
      transparent_extra()

      -- 4. Create an Autocmd so it persists even if you swap themes or reload
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = transparent_extra,
      })
    end,
  },
}
