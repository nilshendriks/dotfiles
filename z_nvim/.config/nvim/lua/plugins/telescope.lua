return {
    {
        "telescope.nvim",
        dependencies = {
            "nvim-telescope/telescope-file-browser.nvim",
            "SalOrak/whaler",
            config = function()
                LazyVim.on_load("telescope.nvim", function()
                    -- snipped loading the extension
                    require("telescope").load_extension("whaler")
                end)
            end,
        },
        opts = {
            defaults = {
                -- telescope.defaults.file_ignore_patterns*
                file_ignore_patterns = { "node_modules", ".git" },
            },
            extensions = {
                whaler = {
                    -- Whaler configuration
                    directories = {
                        "~/Sites",
                        "~/Dev",
                        { path = "~/dotfiles/", alias = "yet" },
                    },
                    file_explorer = "neotree",
                    -- You may also add directories that will not be searched for subdirectories
                    -- oneoff_directories = {
                    --     "path/to/project/folder",
                    --     {
                    --         path = "path/to/another/project",
                    --         alias = "Project Z",
                    --     },
                    -- },
                },
            },
        },
        keys = {
            {
                "<leader>fw",
                function()
                    require("telescope").extensions.whaler.whaler()
                end,
                desc = "Open Whaler Projects",
            },
            {
                "sf",
                function()
                    local telescope = require("telescope")

                    local function telescope_buffer_dir()
                        return vim.fn.expand("%:p:h")
                    end

                    telescope.extensions.file_browser.file_browser({
                        path = "%:p:h",
                        cwd = telescope_buffer_dir(),
                        respect_gitignore = false,
                        hidden = true,
                        grouped = true,
                        previewer = false,
                        initial_mode = "normal",
                        layout_config = { height = 40 },
                    })
                end,
                desc = "Open File Browser with the path of the current buffer",
            },
        },
        -- config = function(_, opts)
        --     local telescope = require("telescope")
        --     local actions = require("telescope.actions")
        --     local fb_actions =
        --         require("telescope").extensions.file_browser.actions
        --
        --     opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
        --         wrap_results = true,
        --         layout_strategy = "horizontal",
        --         layout_config = { prompt_position = "top" },
        --         sorting_strategy = "ascending",
        --         winblend = 0,
        --         mappings = {
        --             n = {},
        --         },
        --     })
        --     opts.pickers = {
        --         diagnostics = {
        --             theme = "ivy",
        --             initial_mode = "normal",
        --             layout_config = {
        --                 preview_cutoff = 9999,
        --             },
        --         },
        --     }
        --     opts.extensions = {
        --         file_browser = {
        --             theme = "dropdown",
        --             -- disables netrw and use telescope-file-browser in its place
        --             hijack_netrw = true,
        --             mappings = {
        --                 -- your custom insert mode mappings
        --                 ["n"] = {
        --                     -- your custom normal mode mappings
        --                     ["N"] = fb_actions.create,
        --                     ["h"] = fb_actions.goto_parent_dir,
        --                     ["/"] = function()
        --                         vim.cmd("startinsert")
        --                     end,
        --                     ["<C-u>"] = function(prompt_bufnr)
        --                         for i = 1, 10 do
        --                             actions.move_selection_previous(
        --                                 prompt_bufnr
        --                             )
        --                         end
        --                     end,
        --                     ["<C-d>"] = function(prompt_bufnr)
        --                         for i = 1, 10 do
        --                             actions.move_selection_next(prompt_bufnr)
        --                         end
        --                     end,
        --                     ["<PageUp>"] = actions.preview_scrolling_up,
        --                     ["<PageDown>"] = actions.preview_scrolling_down,
        --                 },
        --             },
        --         },
        --     }
        --     telescope.setup(opts)
        --     -- require("telescope").load_extension("fzf")
        --     require("telescope").load_extension("file_browser")
        -- end,
    },
}
