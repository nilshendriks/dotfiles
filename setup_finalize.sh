#!/bin/bash

echo ""
echo "<<< Finalizing Setup >>>"
echo ""

TODOS=()

if [[ ! -f "$HOME/.env.local" ]]; then
  TODOS+=("Create ~/.env.local from ~/dotfiles/.env.local.template and fill in secrets (e.g. SHOPIFY_ADMIN_TOKEN)")
fi

if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  TODOS+=("Install tmux plugin manager: git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm")
fi

if [[ ${#TODOS[@]} -gt 0 ]]; then
  echo "⚠️  Post-install TODOs:"
  for item in "${TODOS[@]}"; do
    echo "   • $item"
  done
  echo ""
fi

echo "✅ Setup complete!"
echo "You may still need to restart your terminal to fully apply changes."
