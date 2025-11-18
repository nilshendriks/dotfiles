# Neovim from scratch

## nvim NeoNirusu

- [x] mason tools:
  - [x] black and isort
  - [x] prettier
- [x] check tokyonight transparency
- [x] check lazygit, not installed?
- [x] check who does indent guides?
- [x] turn off dashboard
- [x] how to start wirh lastest session and have a keymap

### LSPs

- [x] html
- [x] css
- [x] js -> vtsls
- [x] ts -> vtsls
- [x] python

### Formatting

- [x] html -> prettierd
  - [x] embedded languages -> prettierd
- [x] css -> prettierd
- [x] json -> prettierd
- [x] lua
- [x] ts -> prettierd
- [x] js -> prettierd
- [x] markdown -> prettierd
- [x] python -> with black and isort. leader c= for indenting
- [x] svg -> as html -> prettier (mason? or in project?)
- [ ] astro
- [ ] vue
- [ ] tsx
- [ ] HTMX
- [x] liquid formatting

## diagnostics

- [x] diagnostics
- [ ] astro
  - [ ] lint -> markuplint + plugin
- [ ] HTMX
  - [ ] lint -> markuplint + plugin
- [ ] json-lsp
  - [ ] format
  - [ ] lint
  - [ ] completion
  - [ ] hover
  - [ ] getColorPresentations returns available color formats for a color symbol
- [ ] write: formatter for svg, like html?
- [ ] try removing lazydev -> vim global, new way?
- [ ] check opencode. works with ollama?
- [ ] astro
  - [ ] formatting
    - [ ] https://dprint.dev/
  - [ ] linting?
  - [ ] browserlist
- [ ] mdx formatting?
- [ ] https://github.com/wuelnerdotexe/vim-astro
- [ ] find and replace in modal?

### Linting

- [ ] css linting -> not yet. maybe stylelint?
- [x] markuplint -> lint html
- [ ] Liquid : try https://www.curlylint.org
- [ ] oxlint or biome for most?
- [ ] jose-elias-alvarez/typescript.nvim

## Other

- [ ] html preview?
- [ ] "kazhala/close-buffers.nvim",
- [x] mdx syntax highlighting
- [ ] pomodory plugin
- [ ] toggle word plugin

## learn

- [ ] change "" to '' on a line?
- [ ] jump to end of {
- [ ] jump to end of block?
- [x] Capitalize word

## Plugins

- [x] markdown?
- [x] 'folke/lazydev.nvim'
- [x] lazy.nvim - folke
- [x] kanagawa
- [x] which key
- [x] sessions - persistence - folke
- [x] primagen line down and up
- [x] sleuth for auto detection tabs / spaces - tpope
- [x] Noice: modal command line - folke
- [x] smear cursor
- [x] tab like buffers ?
- [x] lazygit
- [x] wakatime
- [x] duplicate line instead of v y p.
- [x] treesitter
- [x] mason
- [x] emmet
- [x] mini.statusline
- [x] mini diff
- [x] mini icons
- [x] mini git
- [x] snack dim?
- [x] file explorer -> snacks explorer
- [x] file picker -> snacks picker
- [x] dashboard -> snacks dashobard
- [x] set dashboard graphic -> NeoNirusu

## Options

- [x] number
- [x] relative linenumber
- [x] clipboard setting.

## Keymaps

- [x] w for save?

## Cleanup

- [x] move options from init to config / options file
- [x] move keymaps to config / keymaps file
