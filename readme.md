# Aagedal setup scripts

These scripts will automatically install applications via Homebrew, and also setup system settings.

## Scripts Overview

- `install_brewfile.sh`: Installs Homebrew (if not already installed) and installs packages listed in the `Brewfile`.
- `system_settings.sh`: Configures various macOS system settings.
- `install_config_files.sh`: Clones the repository and copies configuration files to your home directory, with prompts for overwriting existing files.
- `setup_all.sh`: Runs all the above scripts sequentially to perform a complete setup.

## Complete macOS Setup

To perform the entire setup (install Brewfile packages, apply system settings, and copy configuration files), run the following command in your terminal:

```bash
bash <(curl -s https://raw.githubusercontent.com/aagedal/aagedal_macos_config/main/setup_all.sh)
```

The brewfile, config files, and system settings can also be installed separately below.

## Installing Brewfile

To install all packages listed in the Brewfile, run the following command:

```bash
bash <(curl -s https://raw.githubusercontent.com/aagedal/aagedal_macos_config/main/install_brewfile.sh)
```

This should also install Homebrew if it isn't installed.

## macOS System Settings Script

This script configures a variety of macOS settings for macOS Sonoma (14.0) and newer on Apple Silicon Macs. The settings currently include:

- Always displaying file extensions.
- Enabling three-finger drag and tap-to-click for the trackpad.
- Increasing the keyboard key repeat rate.
- Showing the status bar in Finder.
- Setting the Dock to auto-hide and minimizing windows into the application icon.
- Enabling Dark Mode.
- Saving screenshots as JPEG files to a "Screenshots" folder on the Desktop.
- Disabling the Spotlight search keyboard shortcut.

### Requirements

- macOS Sonoma (14.0) or newer
- Apple Silicon Mac

### Usage

To run the script, paste the following command into your terminal:

```bash
bash <(curl -s https://raw.githubusercontent.com/aagedal/aagedal_macos_config/main/system_settings.sh)
```

## Installing Configuration Files

To clone the repository and install all configuration files from the `config_files` directory to your home directory, run:

```bash
bash <(curl -s https://raw.githubusercontent.com/aagedal/aagedal_macos_config/main/install_config_files.sh)
```
