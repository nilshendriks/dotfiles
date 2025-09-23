return {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    config = function()
        require("mason-tool-installer").setup({
            ensure_installed = {
                "markuplint", -- HTML/Liquid linter
                "prettier", -- JS/TS formatter
                "stylua", -- Lua formatter
                "isort", -- for python
                "black", -- python formatter
            },
            auto_update = true,
            run_on_start = true,
        })
    end,
}
