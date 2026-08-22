return {
    "nvim-lualine/lualine.nvim",
    enabled = true,
    opts = {
        options = {
            enabled = true,
            theme = "auto",
            section_separators = "",
            component_separators = "",
        },
        winbar = {
            lualine_c = {
                {
                    function()
                        return require("nvim-navic").get_location()
                    end,
                    cond = function()
                        return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
                    end,
                },
            },
        },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
}
