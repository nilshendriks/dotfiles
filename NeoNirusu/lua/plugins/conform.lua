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
        formatters = {
            prettier = {
                prepend_args = function()
                    if vim.bo.filetype == "svg" then
                        return { "--parser", "html" }
                    end
                    return {}
                end,
            },
            -- astro_formatter = {
            --     command = "my_cmd",
            --     meta = {
            --         description = "Indent <script> and <style> blocks with 2 spaces",
            --     },
            --     run = function(_, bufnr)
            --         require("utils.astro_formatter").format(bufnr)
            --     end,
            -- },
        },
        formatters_by_ft = {
            svg = { "prettier" },
            lua = { "stylua" },
            html = { "prettierd", "prettier", "injected", lsp_format = "fallback" },
            css = { "prettierd" },
            javascript = { "prettierd", "prettier", lsp_format = "fallback" },
            typescript = { "prettier", lsp_format = "fallback" },
            json = { "prettierd", "prettier", lsp_format = "fallback" },
            liquid = { "prettier", "injected", lsp_format = "fallback" },
            markdown = { "prettier" },
            -- NOTE: astro is formatted by LSP (prettier plugin sucks balls)
            -- also runs custom function to format style and script tags with 2 spaces
        },
        -- makes sure the first formatter that works stops
        -- stop_after_first = true,
        stop_after_first = true,
        format_on_save = {
            -- These options will be passed to conform.format()
            timeout_ms = 500,
            -- lsp_format = "fallback",
        },
    },
}
