return {
  "folke/noice.nvim",
  opts = function(_, opts)
    opts.lsp = opts.lsp or {}
    opts.lsp.progress = { enabled = false }
  end,
}
