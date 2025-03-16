#!/bin/bash

# Docker installation script for Ubuntu 24.04 LTS
# This script automates steps 2-11 from the installation guide

# Exit immediately if a command exits with a non-zero status
set -e

# Print commands before executing them
set -x

echo "Step 1: Installing required dependencies"
sudo apt install -y ca-certificates curl gnupg lsb-release

echo "Step 2: Adding Docker's official GPG key"
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "Step 3: Setting up the Docker repository"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Step 4: Updating the package database"
sudo apt update

echo "Step 5: Installing Docker Engine"
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Step 6: Verifying Docker installation"
sudo docker --version
echo "Docker installed successfully!"

echo "Step 7: Running hello-world container to test"
sudo docker run hello-world

echo "Step 8: Adding current user to the docker group"
sudo usermod -aG docker $USER
echo "User added to docker group. You'll need to log out and back in for this change to take effect."

echo "Step 9: Enabling Docker to start on boot"
sudo systemctl enable docker

echo "Step 10: Checking Docker Compose version"
docker compose version || echo "Docker Compose plugin not installed properly"

echo "Installation complete! You may need to log out and back in for the docker group changes to take effect."
echo "After logging back in, you can run Docker commands without sudo."
