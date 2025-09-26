return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        -- "classic" | "modern" | "helix"
        -- preset = "helix",
        preset = "modern",
    },
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)

        -- Use add() instead of register()
        wk.add({
            {
                "<leader>?",
                function()
                    wk.show({ buffer = 0 })
                end,
                desc = "Buffer Local Keymaps",
                hidden = true,
            },
        }, { buffer = 0, mode = "n" })
    end,
}
