#!/bin/bash

# Script to configure a Debian system 

# Basic usage (should be run as root):
# sudo bash Debian12_bookworm_setup.sh

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if we are running as root
# - Installation and packaging should always run as root!
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run as root 'sudo bash $0'"
    exit 1
fi

LOGFILE="/var/log/bookworm.log"

#Check if logfile exists if not create it

if [ ! -f "$LOGFILE" ]; then
    touch "$LOGFILE"
fi

# Save both stdout and stderr to a single file through tee
exec > >(tee $LOGFILE) 2>&1

# Set a timeout for wget (downloads) so the script doesn't hang indefinitely
timeout=10

# System updates
apt -y update
apt -y full-upgrade

# ------------------------------------------------- #
# ----- INSTALL Debian APT AVAILABLE SOFTWARE ----- #
# ------------------------------------------------- #

# Install and start dbus
echo "Installing dbus"
apt install -y dbus
echo "Starting dbus"
systemctl enable dbus
systemctl start dbus

# Install software-properties-common (for apt-add-repository)
echo "Installing software-properties-common"
apt install -y software-properties-common

# Add contrib non-free (rar, etc)
echo "Adding repository components contrib non-free non-free-firmware"
yes | apt-add-repository --component contrib non-free non-free-firmware

# i386 architecture for cross-compilation
echo "Adding architecture i386 to dpkg"
dpkg --add-architecture i386

# General CLI tools
echo "Installing general CLI tools"
apt install -y wget gpg curl apt-transport-https speedtest-cli zip unrar jq htop net-tools bc lzop

# Essential editors
echo "Installing essential editors"
apt install -y nano vim gedit 
 
# Development files, examples, documentation, and misc packages
echo "Installing development files, examples, documentation and misc packages"
apt install -y dbus-x11 libx11-dev libwayland-dev libncurses-dev libssl-dev libcurl4-openssl-dev \
default-libmysqlclient-dev libopendkim-dev libboost-dev libwebsockets-dev libwebsocketpp-dev \
libopencv-dev libreadline-dev libgtk-3-dev libgtksourceview-3.0-1 libsdl2-dev libsdl2-doc \
tcreator qtbase5-dev libqt5x11extras5-dev qtbase5-private-dev qtbase5-examples \
t5-doc qt5-doc-html qtbase5-doc-html libepoxy-dev libpixman-1-dev \
tibsamplerate0-dev libpcap-dev libslirp-dev libelf-dev

# -------------------------------------- #
# ----- GENERAL SOFTWARE AND TOOLS ----- #
# -------------------------------------- #

echo "Installing general software and tools"

# Graphical Uncomplicated Firewall
apt install -y gufw

# Firefox (web browser)
apt install -y firefox-esr

# Evolution & Thunderbird (email clients)
apt install -y evolution thunderbird

# LibreOffice suite
apt install -y libreoffice

# Copy and rip CD media
#apt install -y cdparanoia sound-juicer

# Burn, copy and erase CD and DVD media
#apt install -y brasero

# VLC Media Player
#pt install -y vlc

# ------------------------------------------- #
# ----- INSTALL Debian NON-APT SOFTWARE ----- #
# ------------------------------------------- #

# ------------------------- #
# ----- Google Chrome ----- #
# ------------------------- #

echo "Downloading Google Chrome"
if wget -q --timeout=$timeout https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb; then
    echo "Installing Google Chrome"
    apt install -y ./google-chrome-stable_current_amd64.deb
    rm google-chrome-stable_current_amd64.deb
else
    echo -e "${RED}Failed to download Google Chrome.${NC}"
fi

# ------------------------------ #
# ----- Visual Studio Code ----- #
# ------------------------------ #

curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/keyrings/microsoft-archive-keyring.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/microsoft-archive-keyring.gpg] \
https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get update

if apt-get install -y code; then
    echo "Visual Studio Code installed successfully."
    # Install extensions
    code --install-extension GitHub.copilot
else
    echo -e "Failed to install Visual Studio Code."
fi

echo "****************************************************"
echo "Debian 12 (Bookworm) Package Installation Complete"
echo "****************************************************"
