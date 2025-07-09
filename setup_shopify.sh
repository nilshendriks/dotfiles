#!/usr/bin/env zsh

# Ensure Ruby bin is in PATH (adjust if needed)
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

# Install Shopify CLI gem if not already installed
if ! command -v shopify &>/dev/null; then
  gem install shopify-cli
else
  echo "Shopify CLI already installed"
fi
