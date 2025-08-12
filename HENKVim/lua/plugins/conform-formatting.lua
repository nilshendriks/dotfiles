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
    },
  },
}
-- return {
--   "stevearc/conform.nvim",
--   lazy = true,
--   event = { "BufReadPre", "BufNewFile" },
--   opts = {
--     formatters_by_ft = {
--       -- php = { "php-cs-fixer" },
--       -- twig = { "djlint" },
--       -- liquid = { "prettier-liquid" },
--       -- svg = { "prettier" },
--       html = { "prettier" },
--       css = { "prettier" },
--       javascript = { "prettier" },
--     },
--     formatters = {
--       ["php-cs-fixer"] = {
--         command = "php-cs-fixer",
--         args = {
--           "fix",
--           "--rules=@PSR12", -- Formatting preset. Other presets are available, see the php-cs-fixer docs.
--           "$FILENAME",
--         },
--         stdin = false,
--       },
--       ["djlint"] = {
--         command = "djlint",
--         args = {
--           "--reformat", -- ensures it formats
--           "--preserve-blank-lines",
--           "--quiet", -- suppresses non-error output
--           "--format-css",
--           "--format-js",
--           "--indent-css",
--           "2",
--           "--indent-js",
--           "2",
--           "--no-set-formatting",
--           "--no-function-formatting",
--           "--blank-line-after-tag",
--           "endif",
--           "--blank-line-after-tag",
--           "endfor",
--           "--blank-line-before-tag",
--           "if",
--           "--blank-line-before-tag",
--           "for",
--           "-",
--           -- "$FILENAME",
--         },
--         stdin = true,
--         -- timeout = 20000,
--       },
--     },
--     notify_on_error = true,
--   },
-- }
