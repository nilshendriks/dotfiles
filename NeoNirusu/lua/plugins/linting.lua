return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require("lint")
        local diag = require("utils.diagnostics")
        local lint_augroup = vim.api.nvim_create_augroup("Linting", { clear = true })

        -- Use shared lint namespace
        local lint_ns = diag.lint_ns

        -- Apply common diagnostic config for linting
        -- no need to duplicate signs/virtual_text code
        -- if you want overrides, you can still set them here
        -- vim.diagnostic.config({...}, lint_ns)

        -- linters
        lint.linters_by_ft = {
            html = { "markuplint" },
            -- css = { "biomejs" },
            -- typescript = { "oxlint" },
            -- javascript = { "oxlint" },
        }

        diag.setup_lint()
        -- autocmd for linting on buffer enter and write
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
            group = lint_augroup,
            callback = function(args)
                local bufnr = args.buf or vim.api.nvim_get_current_buf()
                lint.try_lint(nil, {
                    callback = function(diagnostics)
                        -- vim.diagnostic.set(lint_ns, args.buf, diagnostics, {})
                        vim.diagnostic.set(diag.lint_ns, bufnr, diagnostics, {})
                    end,
                })
            end,
        })
    end,
}
