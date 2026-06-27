#!/usr/bin/env zsh

source ~/.zshenv  # for 'exists' function if needed

GITHUB_EMAIL="694301+nilshendriks@users.noreply.github.com"
SSH_KEY="$HOME/.ssh/id_ed25519"

# 1. Elegant Security Header Banner
if command -v gum &>/dev/null; then
    gum style \
        --foreground "#00a8ff" --border-foreground "#00a8ff" \
        --border rounded --align center --width 50 --margin "1 1" \
        "🔒 STARTING SSH SETUP 🔒"
else
    echo "<<< Starting SSH Setup >>>"
fi

# 2. Checklist Key Verification
if [[ -f "$SSH_KEY" ]]; then
    printf "  \033[32m✔\033[0m Local secure cryptographic key identified.\n"
else
    printf "  🔑 \033[1;33mNo active profile found. Generating fresh Ed25519 keypair...\033[0m\n"
    ssh-keygen -t ed25519 -C "$GITHUB_EMAIL" -f "$SSH_KEY" -N "" >/dev/null

    # Initialize agent context silently
    eval "$(ssh-agent -s)" >/dev/null
    ssh-add "$SSH_KEY" >/dev/null 2>&1

    printf "\n  \033[1;32m✨ New Public Key Generated Successfully:\033[0m\n\n"
    cat "${SSH_KEY}.pub" | awk '{print "    " $0}'

    printf "\n  \033[1m📍 Action Required:\033[0m Add this signature to your GitHub dashboard:\n"
    printf "  \033[4;34mhttps://github.com/settings/ssh/new\033[0m\n\n"

    if command -v gum &>/dev/null; then
        gum confirm "Press Enter once the key is saved to your GitHub profile..." || true
    else
        printf "  Press [ENTER] to continue testing..."
        read -r
    fi
fi

# 3. Intercept and beautify the GitHub Remote handshake
# Capture the stderr output safely into a variable to evaluate it
ssh_handshake=$(ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=accept-new -T git@github.com 2>&1)

if [[ "$ssh_handshake" == *"successfully authenticated"* ]]; then
    printf "  \033[32m✔\033[0m GitHub remote connection established securely.\n"
else
    printf "  \033[31m❌ GitHub synchronization check failed.\033[0m\n"
    printf "     ℹ️ %s\n" "$ssh_handshake"
    printf "     Please ensure your key is registered correctly.\n"
fi
