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
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
