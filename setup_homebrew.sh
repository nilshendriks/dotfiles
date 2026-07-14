#!/usr/bin/env zsh

source ~/.zshenv  # for 'exists' function or define it here if you prefer

# 1. The Homebrew Section Header Banner
if command -v gum &>/dev/null; then
    gum style \
        --foreground "#FFA500" --border-foreground "#FFA500" \
        --border rounded --align center --width 50 --margin "1 1" \
        "🍺 STARTING HOMEBREW SETUP 🍺"
else
    echo "<<< Starting Homebrew Setup >>>"
fi

# 2. SILENT CHECK: Only talk if brew is actually missing and needs installing
if ! exists brew; then
  echo "🍺 Homebrew core engine not found. Initiating full network installation..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/tty
fi

# 3. Environment path loading if required
if ! command -v brew >/dev/null 2>&1; then
  if [[ "$(uname -m)" == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# 4. SILENT TRUST: Redirect the tap confirmation noise to the void
brew trust charmbracelet/tap >/dev/null 2>&1 || true
brew trust shopify/shopify >/dev/null 2>&1 || true

# 5. CONTEXT-AWARE STREAMING: Run the bundle, but filter out the administrative noise.
# If an application actually downloads, installs, or errors out, it will stream live.
# brew bundle --upgrade --verbose | awk '!/Skipping install|Using |Already trusted/'

# 5. CONTEXT-AWARE VISUAL TRANSLATOR: Turn raw upgrades into a clean bulleted report
brew bundle --upgrade --verbose | awk '
  # Drop administrative noise and cleanup logs completely
  /Skipping install|Using |Already trusted|Disable this behaviour|Hide these hints|Removing:/ { next }
  /Bottle Manifest/ { next } # Hide redundant manifest checks

  # Group active tasks with distinct status icons
  /^Fetching/   { printf "\n⏳ \033[1;33m%s\033[0m\n", $0; next }
  /^Upgrading/  { printf "🚀 \033[1;34m%s\033[0m\n", $0; next }

  # Turn jagged checkboxes into clean, bright green list items
  /^✔︎/ {
      sub(/^✔︎[ \t]*/, "");
      printf "  \033[32m✔\033[0m %s\n", $0;
      next
  }

  # Clean up and dim the standard Homebrew arrow notifications
  /^==>/ {
      sub(/^==>[ \t]*/, "");
      printf "  \033[90m➔ %s\033[0m\n", $0;
      next
  }

  # Make success messages pop
  /^🍺/ { printf "  \033[32;1m%s\033[0m\n", $0; next }

  # Highlight the final bundle completion metric
  /`brew bundle` complete!/ { printf "\n\033[1;32m%s\033[0m\n", $0; next }

  # Indent generic sub-text slightly so it stays structured
  { print "    " $0 }
'
