-- lua/plugins/cmp.lua
return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
    },
    config = function()
        local cmp = require("cmp")

        local luasnip = require("luasnip")
        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
            completion = {
                completeopt = "menu,menuone,preview,noselect",
            },
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            -- mapping here
            -- sources
            sources = cmp.config.sources({
                { name = "luasnip" },
                { name = "buffer" },
                { name = "path" },
            }),
        })
    end,
}
-- return {
--   "hrsh7th/nvim-cmp",
--   config = function()
--     local cmp = require("cmp")
--     local copilot = require("copilot.client")
--
--     local function setup_cmp_sources()
--       local sources = {
--         { name = "buffer" },
--         { name = "path" },
--         { name = "nvim_lsp" },
--           -- Conditionally include Copilot if not disabled
--         not copilot.is_disabled() and { name = "copilot" } or nil,
--       }
--
--       cmp.setup({
--         sources = vim.tbl_filter(function(source)
--           return source ~= nil
--         end, sources),
--       })
--     end
--
--     setup_cmp_sources()
--
--     -- Reapply sources when Copilot is toggled
--     vim.api.nvim_create_autocmd("User", {
--       pattern = "CopilotToggle",
--       callback = setup_cmp_sources,
--     })
--   end,
-- }
