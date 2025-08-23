return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")

        -- add custom parser for Liquid
        local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

        parser_config.liquid = {
            install_info = {
                url = "https://github.com/hankthetank27/tree-sitter-liquid",
                files = { "src/parser.c", "src/scanner.c" },
                branch = "main",
            },
            filetype = "liquid",
        }

        configs.setup({
            ensure_installed = {
                "c",
                "lua",
                "vim",
                "vimdoc",
                "query",
                "elixir",
                "heex",
                "javascript",
                "html",
                "astro",
                "comment",
                "css",
                "editorconfig",
                "gitcommit",
                "git_config",
                "gitignore",
                "go",
                "graphql",
                "jsdoc",
                "json",
                "jsonc",
                "liquid",
                "markdown",
                "markdown_inline",
                "php",
                "python",
                "scss",
                "toml",
                "tsx",
                "twig",
                "typescript",
                "vue",
                "yaml",
                "xml",
            },
            sync_install = false,
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },

            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<Enter>",
                    node_incremental = "<Enter>",
                    -- scope_incremental = "grc",
                    scope_incremental = false,
                    node_decremental = "<Backspace>",
                },
            },
        })
        -- defer mapping using vim.defer_fn
        -- vim.defer_fn(function()
        --     local parsers = require("nvim-treesitter.parsers")
        --     if parsers.filetype_to_parsername then
        --         parsers.filetype_to_parsername.mdx = "markdown"
        --     end
        -- end, 0)
        -- safely map mdx filetype to TSX parser for JSX highlighting
        -- vim.defer_fn(function()
        --     local ok, parsers = pcall(require, "nvim-treesitter.parsers")
        --     if ok and parsers.filetype_to_parsername then
        --         parsers.filetype_to_parsername.mdx = "tsx"
        --     end
        -- end, 0)
    end
}
