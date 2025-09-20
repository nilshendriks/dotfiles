return {

    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
        lsp = {
            hover = {
                enabled = false,
                -- opts = {
                --     on_open = function(win)
                --         local buf = vim.api.nvim_win_get_buf(win)
                --         local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
                --
                --         -- filter out base64 icons
                --         lines = vim.tbl_filter(function(line)
                --             return not line:match("^!%[.*%]%([^)]*data:image")
                --         end, lines)
                --
                --         vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
                --     end,
                --     border = "rounded",
                -- },
            },
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
