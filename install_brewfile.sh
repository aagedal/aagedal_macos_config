#!/bin/bash

set -euo pipefail

# Define log file
LOG_FILE="/tmp/install_brewfile.log"

# Function to log messages
log() {
  echo "$(date +"%Y-%m-%d %T") : $*" | tee -a "$LOG_FILE"
}

log "Starting Brewfile installation..."

# Check if Homebrew is installed, install if not
if ! command -v brew &>/dev/null; then
  log "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" >> "$LOG_FILE" 2>&1

  # Check if the installation was successful
  if command -v brew &>/dev/null; then
    log "Homebrew installation completed successfully!"
  else
    log "There was an issue installing Homebrew. Please check your internet connection and the log at $LOG_FILE."
    exit 1
  fi
else
  log "Homebrew is already installed. Proceeding with Brewfile installation."
fi

# Download the Brewfile to a temporary location
TEMP_BREWFILE=$(mktemp)
Brewfile_URL="https://raw.githubusercontent.com/aagedal/aagedal_macos_config/main/Brewfile"

log "Downloading Brewfile from $Brewfile_URL..."
if curl -fsSL "$Brewfile_URL" -o "$TEMP_BREWFILE"; then
  log "Brewfile downloaded successfully to $TEMP_BREWFILE."
else
  log "Failed to download Brewfile from $Brewfile_URL. Please check the URL and your internet connection."
  exit 1
fi

# Install Brewfile packages
log "Installing packages from the Brewfile..."
if brew bundle --file="$TEMP_BREWFILE" >> "$LOG_FILE" 2>&1; then
  log "Brewfile installed successfully!"
else
  log "There were issues installing some packages. Please check the Brewfile for errors and review the log at $LOG_FILE."
  rm -f "$TEMP_BREWFILE"
  exit 1
fi

# Clean up the temporary Brewfile
rm -f "$TEMP_BREWFILE"
log "Temporary Brewfile removed."