return {
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = function(_, opts)
          opts.registries = opts.registries or { "github:mason-org/mason-registry" }
          table.insert(opts.registries, 1, "github:Crashdummyy/mason-registry")
        end,
      },
    },
    config = function()
      -- Try to get capabilities from blink, then cmp, then default to neovim built-in
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local has_blink, blink = pcall(require, "blink.cmp")
      local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")

      if has_blink then
        capabilities = blink.get_lsp_capabilities(capabilities)
      elseif has_cmp then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      require("roslyn").setup({
        args = {
          "--stdio",
          "--logLevel=Information",
          "--extensionLogDirectory=" .. vim.fs.joinpath(vim.fn.stdpath("data"), "roslyn"),
        },
        config = {
          on_attach = function(client, bufnr)
            -- Standard LazyVim LSP keymaps/highlights
            require("lazyvim.util").lsp.on_attach(client, bufnr)
          end,
          capabilities = capabilities,
          settings = {
            ["csharp|background_analysis"] = {
              dotnet_analyzer_diagnostics_scope = "fullSolution",
              dotnet_compiler_diagnostics_scope = "fullSolution",
            },
          },
        },
      })
    end,
  },
}
