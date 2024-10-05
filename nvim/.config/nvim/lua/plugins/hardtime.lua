return {
    {
        "m4xshen/hardtime.nvim",
        dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
        config = function()
            require("hardtime").setup({
                disable_mouse = false,
                restricted_keys = {
                    ["j"] = {},
                    ["k"] = {},
                },
                disabled_keys = {
                    ["<Up>"] = { "n", "x" }, -- Disable <Up> in normal and visual mode
                    ["<Down>"] = { "n", "x" }, -- Disable <Down> in normal and visual mode
                    ["<Left>"] = { "n", "x" }, -- Disable <Left> in normal and visual mode
                    ["<Right>"] = { "n", "x" }, -- Disable <Right> in normal and visual mode
                },
            })
        end,
        -- opts = {
        --     -- max_count = 10, -- Set the max count to 10
        --     -- allow_different_key = false, -- Allow different keys to be used
        --     -- Set the minimum options to avoid error
        --     disable_mouse = false,
        --     disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy" }, -- Example filetypes to exclude
        --     restricted_keys = {
        --         ["j"] = {},
        --         ["k"] = {},
        --         ["<Up>"] = {},
        --         ["<Down>"] = {},
        --     },
        --     -- Configure disabled keys
        --     disabled_keys = {
        --         ["<Up>"] = { "n", "x" }, -- Disable <Up> in normal and visual mode
        --         ["<Down>"] = { "n", "x" }, -- Disable <Down> in normal and visual mode
        --         ["<Left>"] = { "n", "x" }, -- Disable <Left> in normal and visual mode
        --         ["<Right>"] = { "n", "x" }, -- Disable <Right> in normal and visual mode
        --     },
        --     hint = true, -- Enable hints when using disabled keys
        --     -- Notifications via nvim-notify or noice.nvim
        --     notification = true,
        --     hints = {
        --         ["[dcyvV][ia][%(%)]"] = {
        --             message = function(keys)
        --                 return "Use "
        --                     .. keys:sub(1, 2)
        --                     .. "b instead of "
        --                     .. keys
        --             end,
        --             length = 3,
        --         },
        --     },
        -- },
    },
}
