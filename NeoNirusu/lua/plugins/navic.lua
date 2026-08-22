return {
    "SmiteshP/nvim-navic",
    dependencies = {
        "neovim/nvim-lspconfig",
    },
    -- opts = function()
    --     Snacks.util.lsp.on({ method = "textDocument/documentSymbol" }, function(buffer, client)
    --         require("nvim-navic").attach(client, buffer)
    --     end)
    --     return {
    --         separator = " ",
    --         highlight = true,
    --         depth_limit = 5,
    --         icons = LazyVim.config.icons.kinds,
    --         lazy_update_context = true,
    --     }
    -- end,

    config = function()
        require("nvim-navic").setup({
            separator = " > ",
            highlight = true,
            depth_limit = 5,
        })
    end,
}
