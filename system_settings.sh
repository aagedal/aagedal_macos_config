#!/bin/bash

set -euo pipefail

# Define log file
LOG_FILE="/tmp/system_settings.log"

# Function to log messages
log() {
  echo "$(date +"%Y-%m-%d %T") : $*" | tee -a "$LOG_FILE"
}

log "Applying macOS system settings..."

# Check for macOS version Sonoma (14.0) or newer
macos_version=$(sw_vers -productVersion | awk -F '.' '{print $1"."$2}')
if [[ "$macos_version" < "14.0" ]]; then
  log "This script requires macOS Sonoma (14.0) or newer."
  exit 1
fi

# Check if running on Apple Silicon
if [[ "$(uname -m)" != "arm64" ]]; then
  log "This script only supports Apple Silicon Macs."
  exit 1
fi

# System Settings
log "Configuring system settings..."

# Always show file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Enable three-finger drag (for Trackpad)
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -bool false

# Enable tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# Increase key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Show status bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true

# Auto-hide the Dock
defaults write com.apple.dock autohide -bool true

# Minimize windows into application icon
defaults write com.apple.dock minimize-to-application -bool true

# Enable dark mode
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Configure screenshot settings
log "Configuring screenshot settings..."
mkdir -p "${HOME}/Desktop/Screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Desktop/Screenshots"
defaults write com.apple.screencapture type -string "jpg"

# Disable Spotlight search shortcut
log "Disabling Spotlight search shortcut..."
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "<dict><key>enabled</key><false/></dict>"

# Speed up Mission Control animations (reducing transition time between spaces)
log "Speeding up Mission Control animations..."
defaults write com.apple.dock expose-animation-duration -float 0.1

# Apply settings
log "Applying changes..."
killall Finder
killall Dock
killall SystemUIServer

log "System settings applied successfully!"