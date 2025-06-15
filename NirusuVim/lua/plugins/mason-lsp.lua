return {
  {
    "mason-org/mason.nvim",
    name = "mason.nvim",
    version = "^1.0.0",
    opts = {
      ensure_installed = {
        "css-lsp", -- Add CSS LSP
      },
    },
  },
  -- 👇 Add this block to pin mason-lspconfig to a safe version
  {
    "mason-org/mason-lspconfig.nvim",
    name = "mason-lspconfig.nvim",
    version = "^1.0.0",
    pin = true,
  },
}
