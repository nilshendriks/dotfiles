return {

    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
        lsp = {
            hover = {
                enabled = false,
            },
            -- override = {
            --     ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            --     ["vim.lsp.util.stylize_markdown"] = true,
            -- },
        },
        routes = {
            {
                filter = { event = "msg_show", kind = "", find = "written" },
                opts = { skip = true },
            },
        },
    },
    dependencies = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        "MunifTanjim/nui.nvim",
        -- OPTIONAL:
        --   `nvim-notify` is only needed, if you want to use the notification view.
        --   If not available, we use `mini` as the fallback
        "rcarriga/nvim-notify",
    },
}
