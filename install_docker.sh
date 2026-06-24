#!/bin/bash

# Docker Installation Script for Debian
# This script automates Docker installation and setup on Debian systems

set -e

echo "=== Starting Docker Installation on Debian ==="

# Update package manager
echo "Updating package manager..."
sudo apt-get update
sudo apt-get upgrade -y

# Install prerequisites
echo "Installing prerequisites..."
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Step 1: Create folder for Docker GPG key
echo "Creating folder for Docker GPG key..."
sudo mkdir -p /etc/apt/keyrings

# Step 2: Download GPG key and setup permissions
echo "Downloading Docker GPG key..."
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set proper permissions on GPG key
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Step 3: Setup Docker repository
echo "Setting up Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package manager with new Docker repository
sudo apt-get update

# Step 4: Install Docker and related packages
echo "Installing Docker and related packages..."
sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# Add current user to docker group (requires logout/login)
echo "Adding current user to docker group..."
sudo usermod -aG docker $USER

# Step 5: Setup Docker to start on boot
echo "Enabling Docker service on boot..."
sudo systemctl enable docker

# Start Docker service immediately
echo "Starting Docker service..."
sudo systemctl start docker

# Verify installation
echo "=== Verifying Docker Installation ==="
docker --version
docker run hello-world

echo "=== Docker Installation Complete ==="
echo "Docker is installed and configured to start on boot."
