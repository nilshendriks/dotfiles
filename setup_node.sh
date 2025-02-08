#!/usr/bin/env zsh

echo "\n<<< Starting Node Setup >>>\n"

# Node versions are managed with n, which is in the brewfile.
# See zshrc for N_Prefix variable and addition to PATH.

if exists node; then
  echo "Node $(node --version) & NPM $(npm --version) already installed"
else
  echo "Installing Node & NPM with n..."
  n latest
fi

# Install Global NPM Packages - if needed
npm install --global json-server
npm install --global http-server

echo "Global NPM Packages Installed:"
npm list --global --depth=0
