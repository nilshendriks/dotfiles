return {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require("bufferline").setup({
            options = {
                mode = "buffers",
                show_buffer_close_icons = false,
                show_close_icon = false,
                separator_style = "slant",
                diagnostics = "nvim_lsp",
            },
        })

        vim.opt.termguicolors = true
        vim.opt.showtabline = 2

        vim.keymap.set('n', '<Tab>', ':BufferLineCycleNext<CR>', { desc = 'Next buffer' })
        vim.keymap.set('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', { desc = 'Previous buffer' })
    end,
}
