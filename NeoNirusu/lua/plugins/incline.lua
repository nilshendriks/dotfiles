return {
    'b0o/incline.nvim',
    event = 'BufReadPre',
    priority = 1200,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("incline").setup({
            window = { margin = { horizontal = 1, vertical = 0 } },
            highlight = {
                groups = {
                    InclineNormal = "Normal",
                    InclineNormalNC = "NormalNC",
                },
            },
            render = function(props)
                local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
                if vim.bo[props.buf].modified then
                    filename = "[+] " .. filename
                end
                return {
                    { filename, guifg = "#ffffff", guibg = "#009ce1"}
                }
            end,
        })
    end,
}
