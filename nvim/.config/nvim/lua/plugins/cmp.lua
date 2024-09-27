return {
    "hrsh7th/nvim-cmp",
    config = function()
        local cmp = require("cmp")
        local copilot = require("copilot.client")

        -- Key mappings for nvim-cmp
        local cmp_mappings = {
            ["<Tab>"] = cmp.mapping.confirm({ select = true }), -- Confirm selection with Tab
            ["<C-n>"] = cmp.mapping.select_next_item({
                behavior = cmp.SelectBehavior.Insert,
            }), -- Navigate down
            ["<C-p>"] = cmp.mapping.select_prev_item({
                behavior = cmp.SelectBehavior.Insert,
            }), -- Navigate up
            ["<Down>"] = cmp.mapping.select_next_item({
                behavior = cmp.SelectBehavior.Insert,
            }), -- Down arrow navigation
            ["<Up>"] = cmp.mapping.select_prev_item({
                behavior = cmp.SelectBehavior.Insert,
            }), -- Up arrow navigation
        }

        -- Setup sources for nvim-cmp
        local function setup_cmp_sources()
            local sources = {
                { name = "buffer" },
                { name = "path" },
                { name = "nvim_lsp" },
                not copilot.is_disabled() and { name = "copilot" } or nil,
            }

            cmp.setup({
                sources = vim.tbl_filter(function(source)
                    return source ~= nil
                end, sources),
                mapping = cmp_mappings, -- Add the keybindings
            })
        end

        setup_cmp_sources()

        -- Reapply sources when Copilot is toggled
        vim.api.nvim_create_autocmd("User", {
            pattern = "CopilotToggle",
            callback = setup_cmp_sources,
        })
    end,
}
-- lua/plugins/cmp.lua
-- return {
--     "hrsh7th/nvim-cmp",
--     event = "InsertEnter",
--     dependencies = {
--         "hrsh7th/cmp-buffer",
--         "hrsh7th/cmp-path",
--         "L3MON4D3/LuaSnip",
--         "saadparwaiz1/cmp_luasnip",
--         "rafamadriz/friendly-snippets",
--     },
--     config = function()
--         local cmp = require("cmp")
--
--         local luasnip = require("luasnip")
--         require("luasnip.loaders.from_vscode").lazy_load()
--
--         cmp.setup({
--             completion = {
--                 completeopt = "menu,menuone,preview,noselect",
--             },
--             snippet = {
--                 expand = function(args)
--                     luasnip.lsp_expand(args.body)
--                 end,
--             },
--             -- mapping here
--             -- sources
--             sources = cmp.config.sources({
--                 { name = "luasnip" },
--                 { name = "buffer" },
--                 { name = "path" },
--             }),
--         })
--     end,
-- }
-- return {
--     "hrsh7th/nvim-cmp",
--     config = function()
--         local cmp = require("cmp")
--         local copilot = require("copilot.client")
--
--         local function setup_cmp_sources()
--             local sources = {
--                 { name = "buffer" },
--                 { name = "path" },
--                 { name = "nvim_lsp" },
--                     -- Conditionally include Copilot if not disabled
--                 not copilot.is_disabled() and { name = "copilot" } or nil,
--             }
--
--             cmp.setup({
--                 sources = vim.tbl_filter(function(source)
--                     return source ~= nil
--                 end, sources),
--             })
--         end
--
--         setup_cmp_sources()
--
--         -- Reapply sources when Copilot is toggled
--         vim.api.nvim_create_autocmd("User", {
--             pattern = "CopilotToggle",
--             callback = setup_cmp_sources,
--         })
--     end,
-- }
