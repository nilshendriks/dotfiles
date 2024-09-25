--formatters.lua
return {
    "stevearc/conform.nvim",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        formatters_by_ft = {
            php = { "php-cs-fixer" },
            javascript = { "biomejs" },
            typescript = { "biomejs" },
            json = { "biomejs" },
            css = { "biomejs" },
            astro = { "prettier-plugin-astro" },
            twig = { "djlint" },
            liquid = { "prettier-liquid" },
            svg = { "prettier" },
        },
        -- Setting the global timeout for formatters
        -- timeout_ms = 30000, -- Timeout in milliseconds (10 seconds)
        formatters = {
            biomejs = {
                -- Use the Mason-installed biome binary
                command = vim.fn.stdpath("data") .. "/mason/bin/biome",
                args = {
                    "format",
                    "--stdin-file-path",
                    "$FILENAME",
                },
                stdin = true,
            },
            -- Prettier for general use
            prettier = {
                command = "npx",
                args = {
                    "prettier",
                    "--stdin-filepath",
                    "$FILENAME",
                },
                stdin = true,
            },
            -- Prettier with Shopify Liquid plugin
            ["prettier-liquid"] = {
                command = "prettier",
                args = {
                    "--plugin=@shopify/prettier-plugin-liquid",
                    "--stdin-filepath",
                    "$FILENAME",
                },
                stdin = true,
            },
            ["php-cs-fixer"] = {
                command = "php-cs-fixer",
                args = {
                    "fix",
                    "--rules=@PSR12", -- Formatting preset. Other presets are available, see the php-cs-fixer docs.
                    "$FILENAME",
                },
                stdin = false,
            },
        },
        notify_on_error = true,
    },
}
