return {
  {
    "mason-org/mason.nvim",
    name = "mason.nvim",
    version = "2.0.1",
    opts = {
      ensure_installed = {
        "astro-language-server",
        "css-lsp",
        "emmet-language-server",
        "html-lsp",
        "vtsls",
        "marksman",
        "css-variables-language-server",
      },
    },
  },
}
