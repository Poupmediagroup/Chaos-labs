#!/bin/bash
#Authored by: Tai.H

echo "inatalling all tooling for Chaos-labs"

# Exit immediately if a command exits with a non-zero status
set -e

# Print commands before executing them
set -x

#Checking if Pipe viewer is installed
if ! command -v pv &> /dev/null; then 
    echo "pv is not installed. Installing now..."
    sudo apt update && sudo apt install pv
fi

#Checking if jq is installed
if ! command -v jq &> /dev/null; then 
    echo "jq is not installed. Installing now..."
    sudo apt install jq
fi

################################################
# Node.js setup
# Install the latest LTS version of Node.js
echo "Installing the latest LTS version of Node.js..."
nvm install --lts

# Set the LTS version as default
nvm alias default 'lts/*'
nvm use default

# Verify installation
echo "Node.js installation complete!"
echo "Node.js version: $(node --version)"
echo "npm version: $(npm --version)"

# Add NVM setup to shell profile if not already added
if ! grep -q "NVM_DIR" ~/.bashrc; then
  echo "Adding NVM to shell profile (~/.bashrc)..."
  echo -e '\n# NVM (Node Version Manager) setup\nexport NVM_DIR="$HOME/.nvm"\n[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"\n[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc
  echo "Added NVM setup to ~/.bashrc"
fi

echo "=== Node.js LTS installation completed successfully ==="
echo "To start using Node.js in the current session, either:"
echo "  1. Close and reopen your terminal"
echo "  2. Run: source ~/.bashrc"
################################################
# Docker setup
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
