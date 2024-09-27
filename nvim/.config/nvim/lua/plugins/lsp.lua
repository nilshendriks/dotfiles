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

            -- Configure HTML LSP
            -- require("lspconfig").html.setup({
            --     on_attach = function(client, bufnr)
            --         -- Additional setup if needed
            --     end,
            --     capabilities = {
            --         -- Your capabilities here
            --     },
            -- })
            -- Configure HTML LSP with minimal setup
            -- require("lspconfig").html.setup({})

            -- Enable snippet support in capabilities
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport =
                true

            -- Configure HTML LSP
            require("lspconfig").html.setup({
                capabilities = require("cmp_nvim_lsp").default_capabilities(
                    capabilities
                ), -- integrate with cmp
            })
        end,
    },
}
