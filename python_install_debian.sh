#!/bin/bash

# Debian 12, and other versions of Debian Linux ship with python (2 and 3) pre-installed. 
# However, if you want to upgrade, it is not advisable to change the default installation. 
# This script downloads the latest Python 3.13 source code, compiles it with optimizations, and installs it alongside the system Python without overwriting it.

# Exit immediately if a command exits with a non-zero status
set -e

# Update this variable if you want a different specific version
# (Though this script fetches the latest 3.13 point release)
# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
VENV_NAME="venv"
PYTHON_VERSION=""
SRC_DIR="/tmp/python_build"

echo "=== Updating system and installing build dependencies ==="
sudo apt update && sudo apt -y upgrade
sudo apt install -y \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libgdbm-dev \
    libdb5.3-dev \
    libbz2-dev \
    libexpat1-dev \
    liblzma-dev \
    tk-dev \
    libffi-dev \
    wget \
    curl

echo "=== Creating build directory ==="
mkdir -p "$SRC_DIR"
cd "$SRC_DIR"

echo "=== Downloading Python $PYTHON_VER sources ==="
wget "https://www.python.org/ftp/python/$PYTHON_VER/Python-$PYTHON_VER.tar.xz"

echo "=== Extracting source archive ==="
tar -xf "Python-$PYTHON_VER.tar.xz"
cd "Python-$PYTHON_VER"

echo "=== Configuring Python build with optimizations ==="
# --enable-optimizations runs Profile Guided Optimization (PGO), making Python ~10-20% faster
./configure --enable-optimizations --with-ensurepip=install

echo "=== Compiling Python (this may take a few minutes) ==="
# Uses all available CPU cores for faster compilation
make -j$(nproc)

echo "=== Installing Python ==="
# CRITICAL: We use altinstall so we don't overwrite the default 'python3' binary 
# that Debian relies on for core system utilities.
sudo make altinstall

# To check if the above version is properly installed and where it is installed

which $PYTHON_VER

echo "=== Cleaning up build files ==="
rm -rf "$SRC_DIR"

echo "=== Installation Complete! ==="
echo "You can now run Python using: python3.13"
python3.13 --version

