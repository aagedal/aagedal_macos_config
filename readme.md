# macOS Setup Script

Automate the setup of your Apple Silicon macOS environment by installing Homebrew, necessary packages, configuring system settings, and applying your preferred configurations.

## Features

- **Homebrew Installation**: Automatically installs Homebrew if it's not already installed and updates it if it is.
- **Brewfile Management**: Installs all packages, casks, and applications listed in the `Brewfile`.
- **System Configuration**: Applies various macOS system settings using `defaults` commands.
- **Oh My Zsh Installation**: Installs Oh My Zsh along with custom configurations, plugins, and themes.
- **Configuration Files**: Copies configuration files to the appropriate directories, backing up existing ones to prevent data loss.

## Repository Structure
├── Brewfile
├── config_files
│   ├── .config
│   │   └── … (your config files)
│   ├── .zshrc
│   ├── file1
│   └── file2
├── setup.sh
└── README.md

- **Brewfile**: Lists all Homebrew packages and casks to be installed.
- **config_files/**: Contains configuration files to be copied to `~/.config` and your home directory, including `.zshrc`.
- **setup.sh**: The main setup script that orchestrates the installation and configuration process.
- **README.md**: This documentation file.

## Quick Install

Run the following single command in your Terminal to execute the setup script directly from the repository:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aagedal/Aagedal_macOS_config/main/setup.sh)"
