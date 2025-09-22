-- utils/diagnostics.lua
local M = {}

M.lint_ns = vim.api.nvim_create_namespace("lint")

function M.setup_lint()
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
                return diagnostic.message
            end,
        },
    }, M.lint_ns)
end

return M
