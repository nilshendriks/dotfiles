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
    -- lsp servers
    {
        "neovim/nvim-lspconfig",
        opts = {
            inlay_hints = { enabled = true },
            -- servers
            servers = {
                cssls = {},
                -- html = {},
            },
        },
        -- config = function()
        --     local capabilities =
        --         require("vim.lsp.protocol").make_client_capabilities()
        --     capabilities.textDocument.formatting = true -- Ensure formatting is enabled
        --     capabilities.textDocument.completion.completionItem.snippetSupport =
        --         true -- Enable snippet support
        --     require("lspconfig").html.setup({
        --         capabilities = capabilities,
        --         settings = {
        --             html = {
        --                 format = {
        --                     enable = true,
        --                     indentInnerHtml = true,
        --                     tabSize = 4,
        --                     useTabs = false,
        --                 },
        --             },
        --         },
        --         on_attach = function(client, bufnr)
        --             -- Format on save
        --             vim.api.nvim_create_autocmd("BufWritePre", {
        --                 buffer = bufnr,
        --                 callback = function()
        --                     vim.lsp.buf.format() -- Use the correct format function
        --                 end,
        --             })
        --         end,
        --     })
        -- end,
    },
}
