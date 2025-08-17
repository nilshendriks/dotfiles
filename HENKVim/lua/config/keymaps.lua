-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Set keybinding for opening Snacks dashboard
-- keymap.set("n", "<leader>db", ":lua require('snacks').dashboard.open()<CR>", opts)
keymap.set(
  "n",
  "<leader>db",
  ":lua Snacks.dashboard.open()<CR>",
  vim.tbl_extend("force", opts, { desc = "Open Dashboard" })
)

-- thanks theprimeagen
-- Move selected lines up/down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Normal mode: move current line up/down
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")
