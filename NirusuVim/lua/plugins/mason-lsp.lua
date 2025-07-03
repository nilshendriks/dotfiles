return {
  {
    "mason-org/mason.nvim",
    name = "mason.nvim",
    -- version = "^1.0.0",
    version = "2.0.0",
    opts = {
      ensure_installed = {
        "css-lsp", -- Add CSS LSP
      },
    },
  },
  -- "williamboman/mason-lspconfig.nvim",
  -- commit = "72346cf3ee1c2e2d5f988be3cbb6f4b95f19f5dd",
  -- 👇 Add this block to pin mason-lspconfig to a safe version
  -- {
  --   "mason-org/mason-lspconfig.nvim",
  --   name = "mason-lspconfig.nvim",
  --   version = "^1.0.0",
  --   pin = true,
  -- },
}
