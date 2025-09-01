-- Line numbers after filetype detection
vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        vim.opt.number = true
        vim.opt.relativenumber = true
    end,
})

-- vim.api.nvim_create_autocmd("LspAttach", {
--     callback = function(args)
--         local client = vim.lsp.get_client_by_id(args.data.client_id)
--         if client and client.server_capabilities.documentFormattingProvider then
--             vim.api.nvim_create_autocmd("BufWritePre", {
--                 buffer = args.buf,
--                 callback = function()
--                     vim.lsp.buf.format({ async = false })
--                     if vim.bo[args.buf].filetype == "astro" then
--                         require("utils.astro_formatter").format_astro(args.buf)
--                     end
--                 end,
--             })
--         end
--     end,
-- })

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

-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--     pattern = "*.astro",
--     callback = function(args)
--         local c = require("conform")
--         c.format_on_save_attach(args.buf) -- attach save hook to this buffer
--     end,
-- })

-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--     pattern = "*.astro",
--     callback = function()
--         local c = require("conform")
--         -- This forces Conform to attach to the buffer
--         if c.attach_to_buffer then
--             c.attach_to_buffer(0)
--         end
--     end,
-- })

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.astro",
    callback = function()
        -- Format the whole buffer with LSP
        vim.lsp.buf.format({ async = false })

        -- Format <script> and <style> blocks with 2 spaces
        require("utils.astro_formatter").format_astro(0)
    end,
})

-- Terminal
vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
    callback = function()
        vim.opt.number = false
        vim.opt.relativenumber = false
    end,
})
