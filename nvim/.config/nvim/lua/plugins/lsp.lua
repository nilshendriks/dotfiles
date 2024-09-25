return {
    -- tools
    {
        "williamboman/mason.nvim",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
        },
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, {
                "stylua",
                "selene",
                "shellcheck",
                "shfmt",
                "html-lsp",
                "css-lsp",
                "twiggy-language-server",
            })
        end,
    },
    -- inlay hints
    {
        "neovim/nvim-lspconfig",
        opts = {
            inlay_hints = { enabled = false },
        },
        config = function()
            require("lspconfig").vtsls.setup({
                on_attach = function(client, bufnr)
                    client.server_capabilities.document_formatting = false
                    client.server_capabilities.document_range_formatting = false
                    client.server_capabilities.text_document_publish_diagnostics =
                        false
                end,
                capabilities = {
                    -- Your capabilities here
                },
            })
        end,
    },
}
