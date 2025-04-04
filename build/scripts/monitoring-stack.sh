#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Setting up the complete monitoring stack: Node Exporter, Prometheus, and Grafana"
echo "-----------------------------------------------------------------------"

# Update package lists
echo "Updating package lists..."
sudo apt-get update

# Install Node Exporter
echo "Installing Node Exporter..."
sudo apt-get install -y prometheus-node-exporter
sudo systemctl enable prometheus-node-exporter
sudo systemctl start prometheus-node-exporter
echo "Node Exporter installed and started."

# Install Prometheus
echo "Installing Prometheus..."
sudo apt-get install -y prometheus
echo "Prometheus installed."

# Configure Prometheus to scrape Node Exporter
echo "Configuring Prometheus to scrape Node Exporter..."
cat << EOF | sudo tee /etc/prometheus/prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 15s
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'node_exporter'
    scrape_interval: 15s
    static_configs:
      - targets: ['localhost:9100']
EOF

# Restart Prometheus to apply new configuration
echo "Restarting Prometheus with new configuration..."
sudo systemctl restart prometheus
sudo systemctl enable prometheus
echo "Prometheus configured and restarted."

# Install Grafana
echo "Installing Grafana..."
sudo apt-get install -y apt-transport-https software-properties-common wget
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt-get install -y grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
echo "Grafana installed and started."

# Display setup information
echo "-----------------------------------------------------------------------"
echo "Your monitoring stack has been installed!"
echo ""
echo "Service locations:"
echo " - Node Exporter: http://localhost:9100/metrics"
echo " - Prometheus: http://localhost:9090"
echo " - Grafana: http://localhost:3000"
echo ""
echo "Default Grafana login: admin/admin"