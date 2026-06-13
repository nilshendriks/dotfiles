return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-mini/mini.icons",
    },
    opts = {
        enabled = false,
        render_modes = {
            "n",
            "c",
            "t",
        },
        injections = {
            gitcommit = {
                enabled = false,
            },
        },
        patterns = {
            markdown = {
                disable = true,
                directives = {},
            },
        },
    },
    -- config = function()
    --     require("render-markdown").setup({
    --         render_modes = { "n", "c", "t" },
    --         checkbox = { checked = { scope_highlight = "@markup.strikethrough" } },
    --     })
    -- end,
}
