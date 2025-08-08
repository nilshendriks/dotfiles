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
# npm install --global json-server
# npm install --global http-server
# npm install --global trash-cli
# npm install --global @mermaid-js/mermaid-cli

# List of global npm packages to install
packages=(
  json-server
  http-server
  trash-cli
  @mermaid-js/mermaid-cli
)

# Install each package if not already installed
for pkg in "${packages[@]}"; do
  if ! npm list -g --depth=0 "$pkg" >/dev/null 2>&1; then
    echo "Installing $pkg..."
    npm install --global "$pkg"
  else
    echo "$pkg is already installed."
  fi
done

echo "Global NPM Packages Installed:"
npm list --global --depth=0
