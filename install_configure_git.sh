#!/bin/bash

set -e

# Set a timeout for wget (downloads) so the script doesn't hang indefinitely
timeout=10

echo "=========================================="
echo "GIT Installation and Configuration Script"
echo "=========================================="


if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

echo "Step 1: Installing GIT"
apt-get update
apt-get install -y git


echo "Step 2: Configuring GIT"


GIT_USERNAME="${1:-}"
GIT_EMAIL="${2:-}"
GIT_EDITOR="${3:-vim}"

if [[ -z "$GIT_USERNAME" ]]; then
    read -p "Enter GIT username: " GIT_USERNAME
fi

if [[ -z "$GIT_EMAIL" ]]; then
    read -p "Enter GIT email: " GIT_EMAIL
fi

read -p "Enter preferred GIT editor (default: vim): " USER_EDITOR
GIT_EDITOR="${USER_EDITOR:-vim}"

echo ""
echo "Configuring username, email, editor, and color settings for GIT..."
echo ""

git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_EMAIL"
git config --global core.editor "$GIT_EDITOR"
git config --global color.ui true


echo "Verification:"
git --version
echo ""
git config --global --list | grep -E "user.name|user.email|core.editor|color.ui"
echo ""

# -------------------------- #
# ----- GitHub Desktop ----- #
# -------------------------- #

echo "Downloading GitHub Desktop GPG key"
if wget -q --timeout=$timeout -O gpg.key https://apt.packages.shiftkey.dev/gpg.key; then
    gpg --dearmor -o /usr/share/keyrings/shiftkey-packages.gpg gpg.key
    rm gpg.key
    sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/shiftkey-packages.gpg]\
    https://apt.packages.shiftkey.dev/ubuntu/ any main" > /etc/apt/sources.list.d/shiftkey-packages.list'
    sudo apt-get update
    echo "Installing GitHub Desktop"
    if apt-get install -y github-desktop; then
        echo "Github Desktop installed successfully."
    else
        echo "Failed to install Github Desktop."
    fi
else
    echo "Failed to download the GPG key for shiftkey - Github Desktop."
fi
