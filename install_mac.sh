#!/bin/zsh

# Step 1: Check if Xcode Command Line Tools are installed
if ! xcode-select -p &>/dev/null; then
    echo "Xcode Command Line Tools not found. Installing..."
    xcode-select --install

    # Wait for the user to manually finish installing (or provide instructions)
    echo "Please complete the installation of Xcode Command Line Tools before proceeding."
    echo "Once done, you can continue with the script."
else
    echo "Xcode Command Line Tools are already installed."
fi
