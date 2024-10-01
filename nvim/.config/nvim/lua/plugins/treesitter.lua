return {
    { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },

    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "astro",
                "bash",
                "html",
                "javascript",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "regex",
                "tsx",
                "typescript",
                "vim",
                "yaml",
                "css",
                "gitignore",
                "http",
                "java",
                "php",
                "scss",
                "sql",
                "svelte",
                "twig",
                "jsdoc",
            },
            highlight = {
                enable = true,
                -- disable treesitter for large files
                disable = function(lang, bufnr) --
                    -- Extend this to other languages by adding `lang == "x"` where x is the language
                    return vim.api.nvim_buf_line_count(bufnr) > 50000
                        and (lang == "css" or lang == "js")
                end,
                additional_vim_regex_highlighting = false,
            },
            -- matchup = {
            -- 	enable = true,
            -- },

            -- https://github.com/nvim-treesitter/playground#query-linter
            query_linter = {
                enable = true,
                use_virtual_text = true,
                lint_events = { "BufWrite", "CursorHold" },
            },

            playground = {
                enable = true,
                disable = {},
                updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
                persist_queries = true, -- Whether the query persists across vim sessions
                keybindings = {
                    toggle_query_editor = "o",
                    toggle_hl_groups = "i",
                    toggle_injected_languages = "t",
                    toggle_anonymous_nodes = "a",
                    toggle_language_display = "I",
                    focus_language = "f",
                    unfocus_language = "F",
                    update = "R",
                    goto_node = "<cr>",
                    show_help = "?",
                },
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)

            -- MDX
            vim.filetype.add({
                extension = {
                    mdx = "mdx",
                },
            })
            vim.treesitter.language.register("markdown", "mdx")
        end,
    },
}
