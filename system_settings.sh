#!/bin/bash

# Check for macOS version Sonoma (14.0) or newer
macos_version=$(sw_vers -productVersion | awk -F '.' '{print $1"."$2}')
if [[ "$macos_version" < "14.0" ]]; then
  echo "This script requires macOS Sonoma (14.0) or newer."
  exit 1
fi

# Check if running on Apple Silicon
if [[ "$(uname -m)" != "arm64" ]]; then
  echo "This script only supports Apple Silicon Macs."
  exit 1
fi

# System Settings
# Always show file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Enable three-finger drag (for Trackpad)
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -bool false

# Trackpad Settings
# Enable tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# Increase key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Finder Settings
# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Dock Settings
# Auto-hide the Dock
defaults write com.apple.dock autohide -bool true

# Minimize windows into application icon
defaults write com.apple.dock minimize-to-application -bool true

# Appearance Settings
# Enable dark mode
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Screenshot Settings
# Set screenshots format to JPEG and save to ~/Desktop/Screenshots
mkdir -p "${HOME}/Desktop/Screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Desktop/Screenshots"
defaults write com.apple.screencapture type -string "jpg"

# Disable Spotlight search shortcut
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "<dict><key>enabled</key><false/></dict>"

# Speed up Mission Control animations (reducing transition time between spaces)
defaults write com.apple.dock expose-animation-duration -float 0.1

# Apply settings
killall Finder
killall Dock
killall SystemUIServer

echo "System settings applied!"