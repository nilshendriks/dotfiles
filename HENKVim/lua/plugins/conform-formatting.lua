-- vim.notify("Loading conform.nvim config", vim.log.levels.INFO)

return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      html = { "prettier", lsp_format = "never" },
      css = { "prettier", lsp_format = "never" },
      js = { "prettier", lsp_format = "never" },
      json = { "prettier", lsp_format = "never" },
      liquid = { "prettier", lsp_format = "never" },
      svg = { "prettier" },
    },
  },
}
