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
                "html",
                "cssls",
                "basedpyright",
                "vtsls",
                "shopify_theme_ls",
                -- "ts_ls", -- TypeScript / JavaScript
                -- "rust_analyzer", -- Rust
                -- "clangd", -- C / C++
            },
        },
    },

    -- nvim-lspconfig: connects Neovim to installed LSP servers
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "WhoIsSethDaniel/mason-tool-installer.nvim",

            -- Useful status updates for LSP.
            { "j-hui/fidget.nvim", opts = {} },

            -- Allows extra capabilities provided by blink.cmp
            "saghen/blink.cmp",
        },
        config = function()
            -- local lspconfig = require("lspconfig")
            -- local server_defs= vim.lsp.config

            -- Capabilities (so completion plugins like nvim-cmp can extend them)
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            if ok_cmp then
                capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
            end

            -- List of servers with per-server settings (extend later if needed)
            local servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            hint = {
                                enable = true,
                            },
                        },
                    },
                },
                html = {
                    filetypes = { "html" },
                },
                cssls = {
                    cmd = { "vscode-css-language-server", "--stdio" }, -- optional if different
                    filetypes = { "css", "scss", "less" }, -- optional if needed
                    capabilities = {},
                    settings = {
                        css = {
                            validate = true,
                            lint = {
                                unknownProperties = "warning",
                                duplicateProperties = "warning", -- <-- this flags duplicates
                                duplicateDeclarations = "warning",
                                emptyRules = "error",
                                importStatement = "warning",
                                zeroUnits = "warning",
                            },
                        },
                        scss = {
                            validate = true,
                            lint = {
                                unknownProperties = "warning",
                                duplicateProperties = "warning",
                            },
                        },
                        less = {
                            validate = true,
                            lint = {
                                unknownProperties = "warning",
                                duplicateProperties = "warning",
                            },
                        },
                    },
                },
                vtsls = {
                    filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
                    settings = {
                        typescript = {
                            inlayHints = {
                                parameterNames = { enabled = "all" },
                                parameterTypes = { enabled = true },
                                variableTypes = { enabled = true },
                                propertyDeclarationTypes = { enabled = true },
                                functionLikeReturnTypes = { enabled = true },
                                enumMemberValues = { enabled = true },
                            },
                        },
                        -- enable JS type checking
                        -- checkJs = true,
                        javascript = {
                            inlayHints = {
                                parameterNames = { enabled = "all" },
                                parameterTypes = { enabled = true },
                                variableTypes = { enabled = true },
                                propertyDeclarationTypes = { enabled = true },
                                functionLikeReturnTypes = { enabled = true },
                                enumMemberValues = { enabled = true },
                            },
                        },
                    },
                },
                basedpyright = {
                    settings = {
                        python = {
                            analysis = {
                                typeCheckingMode = "strict",
                                inlayHints = {
                                    variableTypes = true,
                                    functionReturnTypes = true,
                                    parameterTypes = true,
                                    parameterNames = "all",
                                },
                            },
                        },
                    },
                },
                shopify_theme_ls = {
                    filetypes = { "liquid" },
                },
                -- rust_analyzer = {},
                -- clangd = {},
            }

            for name, cfg in pairs(servers) do
                -- cfg.on_attach = on_attach
                cfg.capabilities = capabilities
                -- lspconfig[name].setup(cfg)
                vim.lsp.config(name, cfg)
                vim.lsp.enable(name)
            end

            -- LspAttach autocmd for inlay hints
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if not client then
                        return
                    end

                    if client.server_capabilities.inlayHintProvider then
                        vim.lsp.inlay_hint.enable(true)
                        print(client.name, "inlay hints enabled")
                    end
                end,
            })

            -- Customize LSP reference highlight groups with bright colors
            -- vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#ff5555", fg = nil }) -- bright red
            -- vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = "#55ff55", fg = nil }) -- bright green
            -- vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = "#ffff55", fg = nil }) -- bright yellow

            vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#3E4451", fg = nil })
            vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = "#2C313A", fg = nil })
            vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = "#5C2A2A", fg = nil })
            --
            -- Optional: define an augroup to ensure clean autocmds
            local hl_augroup = vim.api.nvim_create_augroup("MyLspHighlight", { clear = true })

            -- Attach document highlight on LspAttach
            vim.api.nvim_create_autocmd("LspAttach", {
                group = hl_augroup,
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    -- if client.supports_method("textDocument/documentHighlight") then
                    if client and vim.lsp.client.supports_method(client, "textDocument/documentHighlight") then
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = args.buf,
                            group = hl_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })
                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                            buffer = args.buf,
                            group = hl_augroup,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end
                end,
            })

            -- code actions
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local buf = args.buf
                    -- local ft = vim.api.nvim_buf_get_option(buf, "filetype")
                    local ft = vim.bo[buf].filetype
                    if ft == "css" or ft == "scss" or ft == "less" then
                        return -- skip code actions for CSS files
                    end

                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if not client then
                        return
                    end

                    if client.server_capabilities.codeActionProvider then
                        -- keymap for code actions
                        vim.keymap.set("n", "<leader>ca", function()
                            -- local buf = vim.api.nvim_get_current_buf()
                            -- local clients = vim.lsp.get_active_clients({ bufnr = buf })
                            local clients = vim.lsp.get_clients({ bufnr = buf })
                            local supported = vim.tbl_filter(function(c)
                                return c.supports_method("textDocument/codeAction")
                            end, clients)

                            if #supported == 0 then
                                vim.notify("No LSP code actions available", vim.log.levels.WARN)
                                return
                            end

                            vim.lsp.buf.code_action()
                        end, { buffer = args.buf, desc = "Code Action" })
                    end
                end,
            })

            -- Diagnostic Config
            -- See :help vim.diagnostic.Opts
            -- local diag = require("utils.diagnostics")
            -- diag.setup() -- sets up namespaces and formatting
            -- vim.diagnostic.set(diag.lsp_ns, buf, diagnostics, opts)
            -- local diagnostic_ns = vim.api.nvim_create_namespace("diagnostic")
            --
            vim.diagnostic.config({
                severity_sort = true,
                float = { border = "rounded", source = "if_many" },
                underline = { severity = vim.diagnostic.severity.ERROR },
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "󰅚 ",
                        [vim.diagnostic.severity.WARN] = "󰀪 ",
                        [vim.diagnostic.severity.INFO] = "󰋽 ",
                        [vim.diagnostic.severity.HINT] = "󰌶 ",
                    },
                },
                virtual_text = {
                    source = "if_many",
                    spacing = 2,
                    format = function(diagnostic)
                        -- local diagnostic_message = {
                        --     [vim.diagnostic.severity.ERROR] = diagnostic.message,
                        --     [vim.diagnostic.severity.WARN] = diagnostic.message,
                        --     [vim.diagnostic.severity.INFO] = diagnostic.message,
                        --     [vim.diagnostic.severity.HINT] = diagnostic.message,
                        -- }
                        local source = diagnostic.source or "unknown"
                        local diagnostic_message = {
                            [vim.diagnostic.severity.ERROR] = string.format("[%s] %s", source, diagnostic.message),
                            [vim.diagnostic.severity.WARN] = string.format("[%s] %s", source, diagnostic.message),
                            [vim.diagnostic.severity.INFO] = string.format("[%s] %s", source, diagnostic.message),
                            [vim.diagnostic.severity.HINT] = string.format("[%s] %s", source, diagnostic.message),
                        }
                        return diagnostic_message[diagnostic.severity]
                    end,
                },
            })

            -- TODO: formatting
            -- TODO: linting?
            -- TODO: completion?
        end,
    },
}
