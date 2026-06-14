#!/bin/zsh
set -euo pipefail

XDG_CONFIG_HOME="$HOME/dotfiles" NVIM_APPNAME="NeoNirusu" nvim --headless "+lua local out = vim.api.nvim_exec2('messages', { output = true }).output; if out:match('Error') or out:match('E%d%d%d%d') then print(out); vim.cmd('cq') end" +qa

echo "NeoNirusu startup OK"
