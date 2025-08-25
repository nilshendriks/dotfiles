-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Decrease update time
-- vim.o.updatetime = 250

-- Decrease mapped sequence wait time
-- vim.o.timeoutlen = 300

-- Move selected lines up/down in visual mode
-- thanks theprimeagen
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Normal mode: move current line up/down
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")

-- Save file with Ctrl+S in normal and insert modes
-- vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save file" })
-- vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Save file" })

vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save file", noremap = true, silent = true })
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Save file", noremap = true, silent = true })

-- cycle through buffers without bufferline
vim.keymap.set("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

vim.keymap.set("n", "<leader>d", "yyp", { desc = "Duplicate line" })
vim.keymap.set("v", "<leader>d", "y'>p", { desc = "Duplicate selection" })

-- Keep visual selection after indenting
vim.keymap.set("v", ">", ">gv", { desc = "Indent and stay in visual mode" })
vim.keymap.set("v", "<", "<gv", { desc = "Outdent and stay in visual mode" })

-- Reindent whole file under leader+c=
vim.keymap.set("n", "<leader>c=", "gg=G", { desc = "Reindent whole file" })

vim.keymap.set("n", "<leader>cf", function()
    local ft = vim.bo.filetype
    local bufnr = vim.api.nvim_get_current_buf()
    if ft == "astro" then
        -- Run LSP formatting first
        vim.lsp.buf.format({ async = false })
        -- Then run astro_formatter for script/style blocks
        require("utils.astro_formatter").format_astro(bufnr)
    else
        require("conform").format({ async = true, lsp_fallback = true })
    end
end, { desc = "Format file (context-sensitive)" })
-- vim.keymap.set("n", "<leader>cf", function()
--     local ft = vim.bo.filetype
--     if ft == "astro" then
--         require("utils.astro_formatter").format_astro()
--     else
--         require("conform").format({ async = true, lsp_fallback = true })
--     end
-- end, { desc = "Format file (context-sensitive)" })

-- conform.nvim keymaps
vim.keymap.set("n", "<leader>cF", function()
    require("conform").format({ async = true, lsp_fallback = true, formatters = { "injected" } })
end, { desc = "Format Injected Langs" })
