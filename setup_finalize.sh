#!/usr/bin/env bash

source ~/.zshenv 2>/dev/null || true

if command -v gum &>/dev/null; then
    gum style \
        --foreground "#a3be8c" --border-foreground "#a3be8c" \
        --border rounded --align center --width 50 --margin "1 1" \
        "🏁 FINALIZING SYSTEM SETUP 🏁"
else
    echo "<<< Finalizing Setup >>>"
fi

TODOS=()

# 1. Check for Local Environment Secrets Template
if [[ -f "$HOME/.env.local" ]]; then
    printf "  \033[32m✔\033[0m Local runtime secrets profile detected (~/.env.local)\n"
else
    TODOS+=("Create ~/.env.local from template and add credentials (e.g. SHOPIFY_ADMIN_TOKEN)")
fi

# 2. Check for Tmux Plugin Manager
if [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
    printf "  \033[32m✔\033[0m Tmux Plugin Manager (TPM) subsystem active.\n"
else
    TODOS+=("Install Tmux Plugin Manager: git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm")
fi

# 3. AUTOMATION FIX: Check for Herdr Background Engine
if command -v herdr &>/dev/null; then
    # Look through active brew services to see if it is already flagged as started
    if brew services list 2>/dev/null | grep -qE "herdr[[:space:]]+started"; then
        printf "  \033[32m✔\033[0m Herdr persistent background session daemon active.\n"
    else
        printf "  🚀 \033[1;33mInitializing Herdr background launch engine...\033[0m\n"
        brew services start herdr >/dev/null 2>&1 || true
    fi
fi

# 4. Karabiner Engine Initialization Check
if ! pgrep -x "Karabiner-Menu" >/dev/null && ! pgrep -x "Karabiner-NotificationWindow" >/dev/null; then
    open -a "Karabiner-Elements"
fi

# 5. Format Outstanding Action Items / TODOs
if [[ ${#TODOS[@]} -gt 0 ]]; then
    printf "\n  \033[1;33m⚠️  Post-Installation Tasks Pending:\033[0m\n"
    for item in "${TODOS[@]}"; do
        printf "    \033[1;33m•\033[0m %s\n" "$item"
    done
fi

# 6. Victory Sign-Off Box
if command -v gum &>/dev/null; then
    echo ""
    gum style \
        --foreground "#00ff00" --border-foreground "#00ff00" \
        --border double --align center --width 50 --padding "1 1" --margin "1 1" \
        "✨ BOOTSTRAP SEQUENCE COMPLETE ✨" \
        "" \
        "Please reload or restart your terminal session" \
        "to fully apply all native runtime contexts."
else
    echo ""
    echo "✅ Setup complete!"
    echo "You may still need to restart your terminal to fully apply changes."
fi
