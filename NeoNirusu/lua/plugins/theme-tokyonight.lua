return {
    -- the colorscheme should be available when starting Neovim
    {
        "folke/tokyonight.nvim",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        opts = {
            transparent = true,
        },
        config = function()
            require("tokyonight").setup({
                transparent = true, -- Enable this to disable setting the background color
                -- terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
                styles = {
                    -- Style to be applied to different syntax groups
                    -- Value is any valid attr-list value for `:help nvim_set_hl`
                    comments = { italic = true },
                    keywords = { italic = false, bold = true },
                    functions = { italic = true, bold = true },
                    variables = { italic = false, bold = false },
                    -- Background styles. Can be "dark", "transparent" or "normal"
                    sidebars = "transparent", -- style for sidebars, see below
                    floats = "transparent", -- style for floating windows
                },
                -- hide_inactive_statusline = true,
                -- lualine_bold = true, -- When `true`, section headers in the lualine theme will be bold
                --
                -- on_colors = function(colors)
                --     colors.bg_statusline = colors.none -- To check if its working try something like "#ff00ff" instead of colors.none
                -- end,
            })
            -- load the colorscheme here
            vim.cmd([[colorscheme tokyonight-night]])
        end,
    },
}
