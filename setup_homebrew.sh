#!/usr/bin/env zsh

echo "\n<<< Starting Homebrew Setup >>>\n"

# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# brew install httpie
# brew install bat

# Casks
# brew install --no-quarantine google-chrome
# brew install --no-quarantine firefox@developer-edition
# brew install --no-quarantine visual-studio-code
# brew install --no-quarantine zed

# new to install yet
# brew install ghostty

# later remove current installs and re-install with homebrew
# brew install 1password
# brew install alfred
# brew install wezterm
# brew install

if ! command -v brew &>/dev/null; then
  echo "Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed. Skipping installation."
fi

brew bundle --verbose
