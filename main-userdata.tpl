# !/bin/bash

sudo apt update
mkdir -p $HOME/test-folder

# Update package lists and install prerequisites
sudo apt update && sudo apt install -y software-properties-common wget apt-transport-https

# Add the Grafana GPG key
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -

# Add the Grafana APT repository
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"

# Update package lists again
sudo apt update

# Install Grafana
sudo apt install -y grafana

# Enable Grafana to start at boot
sudo systemctl enable grafana-server

# Start the Grafana service
sudo systemctl start grafana-server

# Check the status of the Grafana service
sudo systemctl status grafana-server
