return {
    "stevearc/conform.nvim",
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
            html = { "prettierd", "prettier", lsp_format = "fallback" },
            css = { "prettierd", lsp_format = "fallback" },
            javascript = { "prettierd", "prettier", lsp_format = "fallback" },
            typescript = { "prettierd", "prettier", lsp_format = "fallback" },
            json = { "prettier", lsp_format = "fallback" },
            liquid = { "prettierd", lsp_format = "fallback" },
        },
        -- makes sure the first formatter that works stops
        stop_after_first = true,
        format_on_save = {
            -- These options will be passed to conform.format()
            timeout_ms = 500,
            lsp_format = "fallback",
        },
    },
}
