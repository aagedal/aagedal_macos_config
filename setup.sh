#!/bin/bash

# Define the base URL for the repository
BASE_URL="https://raw.githubusercontent.com/aagedal/aagedal_macos_config/main"

# Run install_brewfile.sh
echo "Starting Brewfile installation..."
bash <(curl -s $BASE_URL/install_brewfile.sh)

# Run system_settings.sh
echo "Applying macOS system settings..."
bash <(curl -s $BASE_URL/system_settings.sh)

# Run install_config_files.sh
echo "Installing configuration files to the home directory..."
bash <(curl -s $BASE_URL/install_config_files.sh)

echo "All setup tasks completed successfully!"