return {
    {
        "nvim-telescope/telescope.nvim",
        opts = {
            defaults = {
                hidden = true,
            },
        },
        keys = {
            {
                "<leader>ff",
                function()
                    require("telescope.builtin").find_files({ hidden = true })
                end,
                desc = "Find files (including hidden)",
            },
            {
                "<leader>fh",
                function()
                    require("telescope.builtin").find_files({ hidden = true })
                end,
                desc = "Find hidden files",
            },
        },
    },
}

-- return {
--     {
--         "nvim-telescope/telescope.nvim",
--         opts = {
--             defaults = {
--                 hidden = true,
--                 -- keep your other options here
--             },
--         },
--     },
-- }

-- local telescope = require('telescope')

-- telescope.setup {

--     pickers = {

--         find_files = {

--             hidden = true

--         }

--     }
-- }
