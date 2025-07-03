return {
  "stevearc/conform.nvim",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    formatters_by_ft = {
      php = { "php-cs-fixer" },
      -- typescript = { "biomejs" },
      -- json = { "biomejs" },
      -- astro = { "prettier-plugin-astro" },
      twig = { "djlint" },
      -- liquid = { "prettier-liquid" },
      -- svg = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      -- htmldjango = { "djlint" },
      -- css = handled by cssl, the css-lsp
      javascript = { "prettier" },
    },
    -- Setting the global timeout for formatters
    -- timeout_ms = 30000, -- Timeout in milliseconds (10 seconds)
    formatters = {
      -- Prettier for general use
      -- prettier = {
      --   command = "npx",
      --   args = {
      --     "prettier",
      --     "--stdin-filepath",
      --     "$FILENAME",
      --   },
      --   stdin = true,
      -- },
      -- Prettier with Shopify Liquid plugin
      -- ["prettier-liquid"] = {
      --   command = "prettier",
      --   args = {
      --     "--plugin=@shopify/prettier-plugin-liquid",
      --     "--stdin-filepath",
      --     "$FILENAME",
      --   },
      --   stdin = true,
      -- },
      ["php-cs-fixer"] = {
        command = "php-cs-fixer",
        args = {
          "fix",
          "--rules=@PSR12", -- Formatting preset. Other presets are available, see the php-cs-fixer docs.
          "$FILENAME",
        },
        stdin = false,
      },
      ["djlint"] = {
        command = "djlint",
        args = {
          "--reformat", -- ensures it formats
          "--preserve-blank-lines",
          "--quiet", -- suppresses non-error output
          "--format-css",
          "--format-js",
          "--indent-css",
          "2",
          "--indent-js",
          "2",
          "--no-set-formatting",
          "--no-function-formatting",
          "--blank-line-after-tag",
          "endif",
          "--blank-line-after-tag",
          "endfor",
          "--blank-line-before-tag",
          "if",
          "--blank-line-before-tag",
          "for",
          "-",
          -- "$FILENAME",
        },
        stdin = true,
        -- timeout = 20000,
      },
    },
    notify_on_error = true,
  },
}
