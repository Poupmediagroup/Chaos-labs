!#/bin/bash

echo "installing node exporter...."
sudo apt-get install -y prometheus-node-exporter

echo "enabling promethesus-node-exporter...."
sudo systemctl enable prometheus-node-exporter

echo "Starting promethesus-node-exporter service.... "
sudo systemctl start prometheus-node-exporter
