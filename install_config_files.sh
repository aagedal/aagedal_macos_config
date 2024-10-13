#!/bin/bash

set -euo pipefail

# Define variables
REPO_URL="https://github.com/aagedal/aagedal_macos_config.git"
CONFIG_DIR="config_files"
TEMP_DIR=$(mktemp -d)
TARGET_DIR="${HOME}"
LOG_FILE="/tmp/install_config_files.log"

# Ensure cleanup on exit
trap 'rm -rf "$TEMP_DIR"' EXIT

# Function to log messages
log() {
  echo "$(date +"%Y-%m-%d %T") : $*" | tee -a "$LOG_FILE"
}

log "Starting configuration files installation..."

# Clone the repository
log "Cloning repository from $REPO_URL..."
if git clone "$REPO_URL" "$TEMP_DIR" >> "$LOG_FILE" 2>&1; then
  log "Repository cloned successfully."
else
  log "Failed to clone the repository. Check your internet connection and repository URL."
  exit 1
fi

# Check if config_files directory exists
if [ ! -d "$TEMP_DIR/$CONFIG_DIR" ]; then
  log "Config directory '$CONFIG_DIR' not found in the repository."
  exit 1
fi

# Find conflicting files
log "Checking for existing files that will be overwritten..."
CONFLICTS=()
while IFS= read -r -d '' FILE; do
  REL_PATH="${FILE#$TEMP_DIR/$CONFIG_DIR/}"
  if [ -e "$TARGET_DIR/$REL_PATH" ]; then
    CONFLICTS+=("$REL_PATH")
  fi
done < <(find "$TEMP_DIR/$CONFIG_DIR" -type f -print0)

# Handle conflicts
if [ ${#CONFLICTS[@]} -ne 0 ]; then
  log "Warning: The following files already exist and will be overwritten:"
  printf '%s\n' "${CONFLICTS[@]}"
  read -p "Do you want to continue and overwrite these files? (y/n): " CHOICE
  if [[ ! "$CHOICE" =~ ^[Yy]$ ]]; then
    log "Aborting installation of configuration files."
    exit 1
  fi
fi

# Copy configuration files to the home directory
log "Copying configuration files to the home directory..."
if cp -R "$TEMP_DIR/$CONFIG_DIR/." "$TARGET_DIR/"; then
  log "Configuration files copied successfully."
else
  log "Failed to copy configuration files. Check permissions."
  exit 1
fi

log "Configuration files have been successfully installed to the home directory!"