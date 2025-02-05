return {
    -- messages, cmdline and the popupmenu
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        opts = {
            cmdline = {
                view = "cmdline_popup", -- This enables the popup style for the command line
            },
            views = {
                cmdline_popup = {
                    position = {
                        row = "50%", -- Vertically center
                        col = "50%", -- Horizontally center
                    },
                    size = {
                        width = "auto", -- Adjust width based on content
                        height = "auto", -- Adjust height based on content
                    },
                    border = {
                        style = "rounded", -- Optional, can use "none", "single", "double", etc.
                    },
                },
            },
            -- Other options
            presets = {
                bottom_search = false, -- Disable bottom search to avoid conflicts
                command_palette = true, -- Show cmdline with popup menu
                long_message_to_split = true,
                inc_rename = true, -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = true,
            },
        },
        config = function(_, opts)
            -- Setup Noice with options
            require("noice").setup(opts)

            -- LSP Border Configuration without breaking Noice
            local border_opts = { border = "rounded" }
            vim.lsp.handlers["textDocument/hover"] =
                vim.lsp.with(vim.lsp.handlers.hover, border_opts)
            vim.lsp.handlers["textDocument/signatureHelp"] =
                vim.lsp.with(vim.lsp.handlers.signature_help, border_opts)

            -- Set a border for the LspInfo floating window
            require("lspconfig.ui.windows").default_options.border = "rounded"
        end,
    },
}
