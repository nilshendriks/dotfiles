# AGENTS.md

## Scope
This repository is a Neovim configuration (Lua). There are no build/test scripts or CI configs in the repo; behavior is driven by Neovim runtime and plugins.

## Essential commands
- Launch Neovim with this config:
  - `nvim`

> No Makefile, package.json, or CI workflows were found, so no build/test/lint commands are defined in-repo.

## Entry points and structure
- `init.lua` is the entry point. It:
  - Overrides `vim.lsp.util.open_floating_preview` to strip base64 images and unescape some Markdown before showing LSP floats.
  - Loads configuration modules: `config.lazy`, `config.filetype`, `config.options`, `config.keymaps`, `config.autocmds`.
- `lua/config/*.lua` contains core editor settings (options, keymaps, autocmds, filetype additions).
- `lua/plugins/*.lua` contains Lazy.nvim plugin specs and plugin-specific configuration.
- `lua/utils/*.lua` contains utilities (e.g., custom Astro formatter, diagnostic helpers).

## Plugin system
- `lua/config/lazy.lua` bootstraps **lazy.nvim** and imports plugin specs from `lua/plugins/`.
- Plugins are configured as Lazy specs returning tables (see `lua/plugins/*.lua`).

## Formatting
- Formatting is handled by **conform.nvim** (`lua/plugins/conform.lua`).
- `format_on_save` is enabled with a 2s timeout.
- Notable formatter mappings (per filetype):
  - `prettier`/`prettierd` for web files, `black`+`isort` for Python, `stylua` for Lua.
  - SVG files use Prettier with `--parser html`.
- Keymap: `<leader>cf` formats the current buffer.

## Linting & diagnostics
- **nvim-lint** is configured in `lua/plugins/linting.lua`:
  - `markuplint` runs for `html` and `liquid` filetypes.
  - Linting triggers on `BufEnter` and `BufWritePost`.
- A shared diagnostics namespace is set up in `lua/utils/diagnostics.lua`.

## LSP setup
- **mason.nvim** and **mason-lspconfig** install/enable servers in `lua/plugins/lsp.lua`.
- Servers ensured: `lua_ls`, `html`, `cssls`, `basedpyright`, `vtsls`, `shopify_theme_ls`, `gopls`.
- LSP is configured using `vim.lsp.config()` + `vim.lsp.enable()` (Neovim 0.10+ API).
- LSP inlay hints are auto-enabled on attach if the server supports them.

## Treesitter
- **nvim-treesitter** is configured in `lua/plugins/treesitter.lua`.
- Custom Liquid parser is installed from `https://github.com/hankthetank27/tree-sitter-liquid`.

## Filetypes & autocmds
- Additional filetype detection: `mdx` is registered in `lua/config/filetype.lua`.
- Autocmds in `lua/config/autocmds.lua`:
  - Disable conceal for JSON/Markdown.
  - Set `.env` files to `env` filetype and disable diagnostics for that filetype.
  - Force line numbers on `FileType` (to avoid them disappearing).
  - Liquid commentstring is set to `{% comment %} %s {% endcomment %}`.

## Keymap patterns
- Core keymaps live in `lua/config/keymaps.lua`.
- Terminal toggle: `<C-/>` opens/closes a bottom split terminal.
- Navigation keymaps keep search jumps centered (`n`, `N`, `<C-d>`, `<C-u>`).

## UI & UX specifics
- **snacks.nvim** provides dashboard, picker, explorer, notifier, and more (`lua/plugins/snacks.lua`).
  - Explorer replaces netrw.
  - Dashboard header is custom ASCII art.
  - Extensive picker keymaps are defined in this file.

## Style & formatting conventions
- `.editorconfig`:
  - Default indent: 4 spaces.
  - 2-space indentation for web/markdown formats.
  - Markdown/MDX keeps trailing whitespace.

## Gotchas
- LSP floating previews are modified to strip base64 images and unescape some Markdown; if you need raw LSP text, check `init.lua`.
- LSP configuration uses the newer `vim.lsp.config` + `vim.lsp.enable` APIs rather than `lspconfig.setup`.
- Liquid Treesitter parser comes from a non-default repo; updates may require rebuilding parsers via `:TSUpdate`.
