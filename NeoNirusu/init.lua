vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- bootstrap lazy.nvim if not installed
require("config.lazy")

-- general vim options
require("config.options")

-- keymaps
require("config.keymaps")

-- autocmds
require("config.autocmds")

