-- vim.notify("Loading conform.nvim config", vim.log.levels.INFO)

return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      prettier = {
        prepend_args = function()
          if vim.bo.filetype == "svg" then
            return { "--parser", "html" }
          end
          return {}
        end,
      },
    },
    formatters_by_ft = {
      svg = { "prettier" },
      lua = { "stylua" },
      html = { "prettier", lsp_format = "never" },
      css = { "prettier", lsp_format = "never" },
      js = { "prettier", lsp_format = "never" },
      json = { "prettier", lsp_format = "never" },
      liquid = { "prettier", lsp_format = "never" },
    },
    -- makes sure the first formatter that works stops
    stop_after_first = true,
  },
}
