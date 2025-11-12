return {
  {
    "mason-org/mason.nvim", -- <--- This line specifies the plugin
    opts = { -- <--- 'opts' is the key for the config table
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      },
    },
  },
}
