#!/bin/bash

set -euo pipefail

# Define log file
LOG_FILE="/tmp/setup_all.log"

# Function to log messages
log() {
  echo "$(date +"%Y-%m-%d %T") : $*" | tee -a "$LOG_FILE"
}

# Function to compare versions
version_ge() {
  # Returns 0 if $1 >= $2
  # Uses sort -V for version comparison
  [ "$(printf '%s\n' "$1" "$2" | sort -V | head -n1)" = "$2" ]
}

log "Starting complete macOS setup..."

# Check for macOS version
macos_version=$(sw_vers -productVersion)
required_version="14.0"
log "Checking macOS version..."
if ! version_ge "$macos_version" "$required_version"; then
  log "This setup script requires macOS Sonoma ($required_version) or newer. Current version: $macos_version."
  exit 1
fi
log "macOS version is compatible: $macos_version."

# Check if running on Apple Silicon
architecture=$(uname -m)
log "Checking system architecture..."
if [[ "$architecture" != "arm64" ]]; then
  log "This setup script only supports Apple Silicon Macs. Current architecture: $architecture."
  exit 1
fi
log "System architecture is compatible: $architecture."

# Define the base URL for the repository
BASE_URL="https://raw.githubusercontent.com/aagedal/aagedal_macos_config/main"

# Run install_brewfile.sh
log "Starting Brewfile installation..."
if bash <(curl -s "$BASE_URL/install_brewfile.sh") | tee -a "$LOG_FILE"; then
  log "Brewfile installation completed successfully."
else
  log "Brewfile installation encountered errors. Check the log at $LOG_FILE."
  exit 1
fi

# Run system_settings.sh
log "Applying macOS system settings..."
if bash <(curl -s "$BASE_URL/system_settings.sh") | tee -a "$LOG_FILE"; then
  log "System settings applied successfully."
else
  log "System settings script encountered errors. Check the log at $LOG_FILE."
  exit 1
fi

# Run install_config_files.sh
log "Installing configuration files to the home directory..."
if bash <(curl -s "$BASE_URL/install_config_files.sh") | tee -a "$LOG_FILE"; then
  log "Configuration files installed successfully."
else
  log "Configuration files installation encountered errors. Check the log at $LOG_FILE."
  exit 1
fi

log "All setup tasks completed successfully!"