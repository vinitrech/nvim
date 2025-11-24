return {
  {
    "nvim-lua/plenary.nvim",
    init = function()
      vim.filetype.add({
        extension = {
          log = "log",
          config = "xml",
        },
      })
    end,
  },
}
