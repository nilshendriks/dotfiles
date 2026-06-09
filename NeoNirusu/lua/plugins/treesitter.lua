return {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")

        -- add custom parser for Liquid
        local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

        local html_script_type_languages = {
            importmap = "json",
            module = "javascript",
            ["application/ecmascript"] = "javascript",
            ["text/ecmascript"] = "javascript",
        }

        local non_filetype_match_injection_language_aliases = {
            ex = "elixir",
            pl = "perl",
            sh = "bash",
            uxn = "uxntal",
            ts = "typescript",
        }

        local function safe_get_node_text(node, bufnr, metadata)
            if not node then
                return nil
            end

            local ok, text = pcall(vim.treesitter.get_node_text, node, bufnr, metadata)
            if not ok then
                return nil
            end

            return text
        end

        local query = vim.treesitter.query
        local opts = vim.fn.has("nvim-0.10") == 1 and { force = true, all = false } or true

        query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
            local capture_id = pred[2]
            local node = match[capture_id]
            if not node then
                return
            end

            local type_attr_value = safe_get_node_text(node, bufnr)
            if not type_attr_value then
                return
            end

            type_attr_value = type_attr_value:lower()
            local configured = html_script_type_languages[type_attr_value]
            if configured then
                metadata["injection.language"] = configured
            else
                local parts = vim.split(type_attr_value, "/", {})
                metadata["injection.language"] = parts[#parts]
            end
        end, opts)

        query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
            local capture_id = pred[2]
            local node = match[capture_id]
            if not node then
                return
            end

            local injection_alias = safe_get_node_text(node, bufnr)
            if not injection_alias then
                return
            end

            injection_alias = injection_alias:lower()
            local match_ft = vim.filetype.match({ filename = "a." .. injection_alias })
            metadata["injection.language"] = match_ft
                or non_filetype_match_injection_language_aliases[injection_alias]
                or injection_alias
        end, opts)

        query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
            local id = pred[2]
            local node = match[id]
            if not node then
                return
            end

            local text = safe_get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
            if not metadata[id] then
                metadata[id] = {}
            end
            metadata[id].text = string.lower(text)
        end, opts)

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
                "regex",
                "latex",
                "norg",
                "svelte",
                "typst",
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
    end,
}
