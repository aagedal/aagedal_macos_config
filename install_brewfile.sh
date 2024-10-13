#!/bin/bash

# Check if Homebrew is installed, and install it if not
if ! command -v brew &>/dev/null; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Check if the installation was successful
  if command -v brew &>/dev/null; then
    echo "Homebrew installation completed successfully!"
  else
    echo "There was an issue installing Homebrew. Please check your internet connection and try again."
    exit 1
  fi
else
  echo "Homebrew is already installed. Proceeding with Brewfile installation."
fi

# Download and install the Brewfile
echo "Installing packages from the Brewfile..."
brew bundle --file=https://raw.githubusercontent.com/aagedal/aagedal_macos_config/main/Brewfile

echo "Brewfile installation completed successfully!"