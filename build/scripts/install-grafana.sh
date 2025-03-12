#!/bin/bash

# Exit on error
set -e

echo "Installing Grafana on Ubuntu..."

# Install required packages
sudo apt-get install -y apt-transport-https software-properties-common wget

# Create directory for keyrings if it doesn't exist
sudo mkdir -p /etc/apt/keyrings/

# Add Grafana GPG key
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null

# Add Grafana repository for stable releases
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

# Add Grafana repository for beta releases
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com beta main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

# Update package lists
sudo apt-get update

# Install Grafana
sudo apt-get install -y grafana

# Enable and start Grafana service
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Install infinity plug-in
echo "installing infinity plugin..."
grafana-cli plugins install

echo "Grafana installation completed!"
echo "You can access Grafana at http://localhost:3000"
echo "Default login credentials: admin/admin"
