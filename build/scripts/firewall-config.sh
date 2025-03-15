#!/bin/bash

echo "Configuring firewall for services: Grafana, Node Exporter, Prometheus"

# Ensure UFW is installed
if ! command -v ufw &> /dev/null; then
    echo "UFW is not installed. Installing now..."
    sudo apt update && sudo apt install -y ufw
fi

# Enable UFW if not already enabled
echo "Enabling UFW..."
sudo ufw enable

# Allow necessary ports
echo "Opening Port 3000 for Grafana"
sudo ufw allow 3000/tcp

echo "Opening Port 9090 for Prometheus"
sudo ufw allow 9090/tcp

echo "Opening Port 9100 for Node Exporter"
sudo ufw allow 9100/tcp

# Reload UFW to apply changes
echo "Reloading firewall rules..."
sudo ufw reload

# Show active rules
echo "Firewall rules applied successfully. Current UFW status:"
sudo ufw status verbose
