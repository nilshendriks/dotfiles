-- autocmds.lua
local augroup = vim.api.nvim_create_augroup("CustomFiletypes", { clear = true })

-- JSON / Markdown: disable conceal
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = { "json", "jsonc", "markdown" },
    callback = function()
        vim.wo.conceallevel = 0
        vim.opt.conceallevel = 0
    end,
})

-- .env filetype detection
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = augroup,
    pattern = { ".env", ".env.*", "*.env" },
    callback = function()
        vim.bo.filetype = "env"
    end,
})

-- Disable diagnostics for .env files
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = "env",
    callback = function()
        local ns = vim.api.nvim_create_namespace("shellcheck")
        vim.diagnostic.enable(false, { namespace = ns })
    end,
})

-- Line numbers after filetype detection
-- I did this cause sometimes they would disappear...?
vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        vim.opt.number = true
        vim.opt.relativenumber = true
    end,
})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

-- vim.api.nvim_create_autocmd("BufWritePre", {
--     pattern = "*.astro",
--     callback = function()
--         -- Format the whole buffer with LSP
--         vim.lsp.buf.format({ async = false })
--
--         -- Format <script> and <style> blocks with 2 spaces
--         require("utils.astro_formatter").format_astro(0)
--     end,
-- })

-- Terminal
-- vim.api.nvim_create_autocmd("TermOpen", {
--     group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
--     callback = function()
--         vim.opt.number = false
--         vim.opt.relativenumber = false
--     end,
-- })
