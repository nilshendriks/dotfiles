-- Set the Python 3 host program
-- vim.g.python3_host_prog = "/usr/local/bin/python3"
--
-- vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.stdpath("data") .. "/mason/bin"

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
