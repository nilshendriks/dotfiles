#!/usr/bin/env zsh

source ~/.zshenv  # for 'exists' function or define it here if you prefer

# 1. Elegant Node Header Banner
if command -v gum &>/dev/null; then
    gum style \
        --foreground "#089cec" --border-foreground "#067cbc" \
        --border rounded --align center --width 50 --margin "1 1" \
        "📦 STARTING NODE SETUP 📦"
else
    echo "<<< Starting Node Setup >>>"
fi

# 2. Colorized Node & NPM Status Verification
if exists node; then
    printf "  \033[32m✔\033[0m Node \033[1m%s\033[0m & NPM \033[1m%s\033[0m are up to date.\n" "$(node --version)" "$(npm --version)"
else
    printf "  ⏳ \033[1;33mNode environment not found. Installing latest via n...\033[0m\n"
    n latest
fi

# 3. Target Global Packages array
packages=(
    json-server
    http-server
    trash-cli
    @mermaid-js/mermaid-cli
    ntl
    @earendil-works/pi-coding-agent
)

# 4. Silent Verification Loop (Only speaks if it is actively installing something)
for pkg in "${packages[@]}"; do
    if ! npm list -g --depth=0 "$pkg" >/dev/null 2>&1; then
        printf "  🚀 \033[1;33mInstalling global package: %s...\033[0m\n" "$pkg"
        npm install --global "$pkg" >/dev/null 2>&1
    fi
done

# 5. Visual Summary Translator: Turns the raw npm list tree into clean bullet points
printf "\n\033[1mGlobal NPM Packages Installed:\033[0m"

npm list --global --depth=0 2>/dev/null | awk '
  # Format the system directory path layout subtly
  /lib$/ { printf "\n  \033[90m📍 Environment: %s\033[0m\n", $0; next }

  # Strip out the ugly tree branches and format into clean green bullets
  /├──|└──/ {
      sub(/^[├└]──[ \t]*/, "");
      printf "    \033[32m•\033[0m %s\n", $0;
      next
  }
  { next }
'
