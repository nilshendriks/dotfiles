-- local formatter = require("utils.formatter")
return {
    "stevearc/conform.nvim",
    lazy = false,
    keys = {
        {
            -- Customize or remove this keymap to your liking
            "<leader>cf",
            function()
                require("conform").format({ async = true })
            end,
            mode = "",
            desc = "Format buffer",
        },
    },
    opts = {
        formatters_by_ft = {
            -- oxfmt
            html = { "oxfmt", lsp_format = "never" },
            -- html = { "oxfmt", "injected", stop_after_first = false },
            css = { "oxfmt", lsp_format = "never" },
            markdown = { "oxfmt", lsp_format = "never" },
            javascript = { "oxfmt", lsp_format = "never" },
            typescript = { "oxfmt", lsp_format = "never" },
            vue = { "oxfmt", lsp_format = "never" },
            -- typescript = { "oxfmt", "injected", lsp_format = "never", stop_after_first = false },
            json = { "oxfmt", lsp_format = "never" },
            jsonc = { "oxfmt", lsp_format = "never" },
            yaml = { "oxfmt", lsp_format = "never" },
            toml = { "oxfmt", lsp_format = "never" },

            -- prettier
            astro = { "prettier", lsp_format = "never" },
            svg = { "prettier", lsp_format = "never", stop_after_first = true },
            liquid = { "prettier", lsp_format = "fallback" },
            -- javascript = { "prettier", lsp_format = "never" },
            -- typescript = { "prettier", "injected", lsp_format = "never", stop_after_first = false },
            -- json = formatter.json,
            -- jsonc = formatter.jsonc,

            -- other
            lua = { "stylua" },
            python = { "isort", "black" },
        },
        -- Set default options
        default_format_opts = {
            lsp_format = "fallback",
        },
        -- makes sure the first formatter that works stops
        -- stop_after_first = true,
        -- this creates an autocmd for buwritepre
        format_on_save = {
            -- These options will be passed to conform.format()
            timeout_ms = 2000,
            -- lsp_format = "fallback",
        },
        -- customize formatters
        formatters = {
            -- oxfmt = {
            --     prepend_args = {
            --         "--config",
            --         vim.fn.expand("~/dotfiles/oxfmt/oxfmt.json"),
            --     },
            -- },
            injected = {
                options = {
                    -- Set individual option values
                    ignore_errors = true,
                    lang_to_ft = {
                        css = "css",
                        javascript = "javascript",
                        typescript = "typescript",
                    },
                    lang_to_formatters = {
                        css = { "prettierd" },
                        javascript = { "prettierd" },
                        typescript = { "prettierd" },
                    },
                },
            },
            prettier = {
                prepend_args = function()
                    if vim.bo.filetype == "svg" then
                        return { "--parser", "html" }
                    end
                    -- if vim.bo.filetype == "astro" then
                    --     return {
                    --         "--plugin",
                    --         "/Users/nirusu/Sites/nilshendriks.com/node_modules/prettier-plugin-astro/dist/index.js",
                    --     }
                    -- end
                    return {}
                end,
            },
        },
    },
}
