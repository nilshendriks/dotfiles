return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      jsonls = {
        filetypes = { "json", "jsonc" },
        settings = {
          json = {
            validate = true,
          },
        },
      },
      cssls = {
        settings = {
          css = {
            lint = {
              unknownAtRules = "ignore",
            },
          },
        },
      },
    },
  },
}
