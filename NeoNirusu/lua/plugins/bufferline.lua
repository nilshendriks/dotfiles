return {
    'akinsho/bufferline.nvim',
    enabled = false,
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {},
    config = function(_, opts)
    require("bufferline").setup(opts)

    -- keymaps for moving between buffers
    vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { silent = true })
    vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { silent = true })

    -- pinning
    vim.keymap.set("n", "<leader>bp", ":BufferLineTogglePin<CR>", { silent = true, desc = "Toggle pin for buffer" })

  end,
}
