return {
  {
    "folke/snacks.nvim",
    config = function()
      require("snacks").setup({
        dashboard = { enabled = true },
        explorer = { enabled = true },
        -- image = { enabled = true },
        image = {
          enabled = true,
          doc = {
            enabled = true,
            inline = false, -- or false to try floating window
            float = true,
            max_width = 80, -- limits image width in chars
            max_height = 40, -- limits image height in chars
            conceal = function(lang, type)
              return type == "math" -- only conceal math images
            end,
          },
          wo = {
            wrap = false,
            number = false,
            relativenumber = false,
            cursorcolumn = false,
            signcolumn = "no",
            foldcolumn = "0",
            list = false,
            spell = false,
            statuscolumn = "",
          },
        },
      })
    end,
  },
}
-- return {
--   {
--     "folke/snacks.nvim",
--     config = function()
--       require("snacks").setup({
--         -- dashboard = {
--         --   keys = {
--         --     f = {
--         --       function()
--         --         require("telescope.builtin").find_files({
--         --           find_command = {
--         --             "fd",
--         --             "--type",
--         --             "f",
--         --             "--hidden",
--         --             "--exclude",
--         --             "node_modules",
--         --             "--color",
--         --             "never",
--         --             "--no-require-git",
--         --           },
--         --         })
--         --       end,
--         --       "Find files (exclude node_modules)",
--         --     },
--         --   },
--         -- },
--         explorer = {
--           enabled = true,
--           -- You can add more explorer config options here if you want
--         },
--         image = {
--           enabled = true,
--         },
--       })
--     end,
--   },
-- }
