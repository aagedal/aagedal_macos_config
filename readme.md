# Aagedal setup scripts

These scripts will automatically install applications via Homebrew, and also setup system settings.

## Complete macOS Setup

To install all Brewfile packages, apply macOS system settings, and copy configuration files to your home directory, run the following command:

```bash
bash <(curl -s https://raw.githubusercontent.com/aagedal/aagedal_macos_config/main/setup_all.sh)
```

The brewfile and system settings can also be installed separately below.

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
