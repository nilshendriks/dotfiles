#!/usr/bin/env zsh

GITHUB_EMAIL="694301+nilshendriks@users.noreply.github.com"
SSH_KEY="$HOME/.ssh/id_ed25519"

echo "Checking for existing SSH key..."

if [[ -f "$SSH_KEY" ]]; then
  echo "SSH key found at $SSH_KEY"
else
  echo "No SSH key found, generating a new one..."
  ssh-keygen -t ed25519 -C "$GITHUB_EMAIL" -f "$SSH_KEY" -N ""

  echo "Adding SSH key to ssh-agent..."
  eval "$(ssh-agent -s)"
  ssh-add "$SSH_KEY"

  echo "\nYour new SSH public key is:\n"
  cat "${SSH_KEY}.pub"
  echo "\nCopy the above key and add it to your GitHub account here:"
  echo "https://github.com/settings/ssh/new"
fi

echo "Testing SSH connection to GitHub..."
ssh -T git@github.com || echo "Please make sure your SSH key is added to GitHub."
