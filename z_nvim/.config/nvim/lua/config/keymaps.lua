-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Dashboard
keymap.set("n", "<leader>db", ":Dashboard<CR>", opts)

-- thanks theprimeagen
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- disable arrow keys
keymap.set("n", "<Up>", "<Nop>", opts)
keymap.set("n", "<Down>", "<Nop>", opts)
keymap.set("n", "<Left>", "<Nop>", opts)
keymap.set("n", "<Right>", "<Nop>", opts)
