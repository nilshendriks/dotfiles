return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-mini/mini.icons",
    },
    opts = {
        render_modes = {
            "n",
            "c",
            "t",
        },
    },
    -- config = function()
    --     require("render-markdown").setup({
    --         render_modes = { "n", "c", "t" },
    --         checkbox = { checked = { scope_highlight = "@markup.strikethrough" } },
    --     })
    -- end,
}
