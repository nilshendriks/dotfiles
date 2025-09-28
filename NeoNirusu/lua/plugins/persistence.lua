return {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {
        -- add any custom options here
    },
}
-- return {
--     "folke/persistence.nvim",
--     -- event = "BufReadPre", -- lazy-load on startup
--     lazy = false,
--     opts = {
--         dir = vim.fn.stdpath("data") .. "/sessions/",
--         save = true,
--     },
--     config = function(_, opts)
--         require("persistence").setup(opts)
--
--         -- Auto-load last session on startup
--         vim.api.nvim_create_autocmd("VimEnter", {
--             callback = function()
--                 -- delay a tick so plugins & filetypes are loaded
--                 vim.schedule(function()
--                     require("persistence").load()
--                 end)
--             end,
--         })
--     end,
--     keys = {
--         {
--             "<leader>qs",
--             function()
--                 require("persistence").load()
--             end,
--             desc = "Restore last session for current directory",
--         },
--         -- select a session to load
--         {
--             "<leader>qS",
--             function()
--                 require("persistence").select()
--             end,
--             desc = "Select a session",
--         },
--     },
-- }
