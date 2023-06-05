#!/bin/bash

# Download and extract node_exporter
sudo wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz
sudo tar xvzf node_exporter-1.5.0.linux-amd64.tar.gz

# Create the node_exporter user
sudo useradd -rs /bin/false node_exporter

# Move into the node_exporter directory
cd node_exporter-1.5.0.linux-amd64/

# Copy node_exporter binary to /usr/local/bin
sudo cp node_exporter /usr/local/bin

# Set ownership to the node_exporter user
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

# Create and edit the systemd service file
sudo tee /lib/systemd/system/node_exporter.service > /dev/null <<EOT
[Unit]
Description=Node Exporter
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOT

# Reload systemd daemon and start node_exporter
sudo systemctl daemon-reload
sudo systemctl start node_exporter

# Check the status of node_exporter
systemctl status node_exporter
