#!/bin/bash

# Define variables
REPO_URL="https://github.com/aagedal/aagedal_macos_config"
CONFIG_DIR="config_files"
TEMP_DIR=$(mktemp -d)
TARGET_DIR="${HOME}"

# Download and extract config_files directory
echo "Downloading configuration files..."
curl -sL "${REPO_URL}/archive/refs/heads/main.zip" -o "${TEMP_DIR}/config.zip"
unzip -q "${TEMP_DIR}/config.zip" -d "$TEMP_DIR"

# Check for conflicts
CONFLICTS=()
for FILE in "$TEMP_DIR/${CONFIG_DIR}-main/"*; do
  FILENAME=$(basename "$FILE")
  if [ -e "$TARGET_DIR/$FILENAME" ]; then
    CONFLICTS+=("$FILENAME")
  fi
done

# Handle conflicts
if [ ${#CONFLICTS[@]} -ne 0 ]; then
  echo "Warning: The following files already exist and will be overwritten:"
  printf '%s\n' "${CONFLICTS[@]}"
  read -p "Do you want to continue and overwrite these files? (y/n): " CHOICE
  if [[ ! "$CHOICE" =~ ^[Yy]$ ]]; then
    echo "Aborting installation of configuration files."
    rm -rf "$TEMP_DIR"
    exit 1
  fi
fi

# Copy the contents of config_files to the home directory
echo "Copying configuration files to the home directory..."
cp -r "$TEMP_DIR/${CONFIG_DIR}-main/"* "$TARGET_DIR/"

# Clean up by removing the temporary directory
rm -rf "$TEMP_DIR"

echo "Configuration files have been successfully installed to the home directory!"