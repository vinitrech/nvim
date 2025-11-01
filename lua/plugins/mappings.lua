return {
  {
    "AstroNvim/astrocore",
    opts = {
      mappings = {
        n = {
          ["<C-d>"] = { "<C-d>zz", desc = "Adds a center instruction after navigating half screen down"},
          ["<C-u>"] = { "<C-u>zz", desc = "Adds a center instruction after navigating half screen up"}
        },
      }
    }
  }
}
