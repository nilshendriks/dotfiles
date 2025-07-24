return {
  -- Emmet Language Server config for LazyVim
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        emmet_language_server = {
          -- Add your settings here if needed
          filetypes = { "html", "css", "javascript", "typescriptreact", "javascriptreact", "liquid" },
          init_options = {
            html = {
              options = {},
            },
          },
        },
      },
    },
  },
}
