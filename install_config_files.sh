#!/bin/bash

# Define variables
REPO_URL="https://github.com/aagedal/aagedal_macos_config.git"
TEMP_DIR=$(mktemp -d)
TARGET_DIR="${HOME}"

# Clone the repository
echo "Cloning repository..."
git clone "$REPO_URL" "$TEMP_DIR"

# Check if cloning was successful
if [ $? -ne 0 ]; then
  echo "Failed to clone the repository. Please check your internet connection and try again."
  exit 1
fi

# Copy the contents of config_files to the home directory
echo "Copying configuration files to the home directory..."
cp -r "$TEMP_DIR/config_files/." "$TARGET_DIR"

# Clean up by removing the temporary directory
rm -rf "$TEMP_DIR"

echo "Configuration files have been successfully installed to the home directory!"