return {
    -- Mason: installs and manages external tools like LSP servers
    {
        "mason-org/mason.nvim",
        opts = {},
    },

    -- Mason-LSPConfig: tells Mason which servers to install and links them to lspconfig
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            ensure_installed = {
                "lua_ls", -- Lua (great for editing Neovim config)
                "pyright", -- Python
                "vtsls",
                -- "ts_ls", -- TypeScript / JavaScript
                -- "rust_analyzer", -- Rust
                -- "clangd", -- C / C++
            },
        },
    },

    -- nvim-lspconfig: connects Neovim to installed LSP servers
    {
        "neovim/nvim-lspconfig",
        opts = {
            inlay_hints = { enabled = true },
        },
        config = function()
            local lspconfig = require("lspconfig")

            lspconfig.lua_ls.setup({})
            lspconfig.vtsls.setup({})
            -- lspconfig.pyright.setup({})
            -- lspconfig.ts_ls.setup({})
            -- lspconfig.rust_analyzer.setup({})
            -- lspconfig.clangd.setup({})
        end,
    },
}
