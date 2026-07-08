# AGENTS.md

## Scope

This repository contains my personal Neovim configuration ("NeoNirusu"), written in Lua and managed with Lazy.nvim.

Always prefer understanding the existing architecture before introducing new plugins, abstractions, or duplicate functionality.

---

# Architecture

## Entry point

- `init.lua`

It loads:

- `config.lazy`
- `config.options`
- `config.keymaps`
- `config.autocmds`
- `config.filetype`

Core editor behavior belongs in `lua/config`.

Plugin configuration belongs in `lua/plugins`.

Reusable helper functions belong in `lua/utils`.

---

# Plugin Manager

Plugins are managed with **Lazy.nvim**.

Each file in:

```
lua/plugins/
```

returns a Lazy.nvim plugin specification.

Do not introduce alternative plugin-loading patterns.

---

# LSP Architecture

This configuration uses the **Neovim 0.11+ native LSP API**.

Use:

```lua
vim.lsp.config(...)
vim.lsp.enable(...)
```

Do **not** use legacy:

```lua
require("lspconfig").XYZ.setup(...)
```

unless absolutely required for compatibility.

## Responsibilities

### mason.nvim

Only installs binaries.

It does **not** configure or start language servers.

### mason-lspconfig.nvim

Automatically enables installed language servers by default using:

```lua
vim.lsp.enable(...)
```

Therefore:

- installed ≠ configured
- configured ≠ attached

Many servers do not need explicit entries in `lsp.lua`.

### lsp.lua

`lua/plugins/lsp.lua` exists primarily for:

- custom settings
- capabilities
- root_dir overrides
- on_attach logic
- server-specific configuration

Avoid adding a server here unless customization is required.

---

# Formatting

Formatting is handled by **conform.nvim**.

Responsibilities:

- formatter selection
- format on save
- manual formatting

Do not use LSP formatting when Conform already formats that filetype.

Avoid duplicate formatters.

---

# Diagnostics

Diagnostics may originate from:

- LSP
- nvim-lint

These are separate systems.

Avoid configuring both for the same tool unless intentional.

Example:

Good:

- oxlint LSP
- markuplint via nvim-lint

Bad:

- oxlint LSP
- oxlint via nvim-lint

because diagnostics become duplicated.

---

# Treesitter

Treesitter provides parsing and highlighting.

It is **not** responsible for:

- formatting
- linting
- LSP

Keep these concerns separate.

---

# Project philosophy

Prefer:

- native Neovim APIs
- small focused plugins
- explicit configuration
- simple architecture

Avoid:

- unnecessary abstraction
- duplicate tooling
- overlapping plugins
- magic unless it clearly simplifies maintenance

---

# Coding style

When modifying this configuration:

- preserve existing formatting
- prefer descriptive variable names
- keep modules focused
- avoid unnecessary helper functions
- avoid introducing global state

When adding new functionality:

- integrate with the existing architecture
- reuse utilities where appropriate
- keep configuration consistent with neighboring files

---

# Debugging

When investigating issues, first determine which subsystem is responsible.

Typical order:

1. filetype detection
2. LSP
3. formatter (Conform)
4. linter (nvim-lint)
5. Treesitter
6. plugin interaction

Do not assume a problem belongs to LSP until verified.

---

# Important distinctions

These terms are different:

- Installed
- Registered
- Enabled
- Attached

For LSPs:

Installed
→ Mason downloaded the binary.

Registered
→ `vim.lsp.config.<server>` exists.

Enabled
→ `vim.lsp.enable("<server>")` has been called.

Attached
→ The server is active for the current buffer.

Understanding these distinctions is essential when debugging.
