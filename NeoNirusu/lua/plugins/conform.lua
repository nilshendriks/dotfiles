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
            -- good
            html = { "prettierd", "injected", stop_after_first = false },
            css = { "prettierd", lsp_format = "never" },
            javascript = { "prettierd", lsp_format = "never" },
            typescript = { "prettierd", lsp_format = "never" },
            python = { "isort", "black" },
            lua = { "stylua" },
            -- dubious
            markdown = { "prettierd", lsp_format = "never" },
            svg = { "prettier", lsp_format = "never", stop_after_first = true },
            json = { "prettierd", lsp_format = "fallback" },
            jsonc = { "prettierd", lsp_format = "fallback" },
            liquid = { "prettier", lsp_format = "fallback" },
            -- NOTE: astro is formatted by LSP (prettier plugin sucks balls)
            -- also runs custom function to format style and script tags with 2 spaces
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
                    return {}
                end,
            },
        },
    },
}
