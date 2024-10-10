#!/bin/bash

set -euo pipefail

# Function to print messages
print_info() {
    echo -e "\033[1;34m[INFO]\033[0m $1"
}

print_success() {
    echo -e "\033[1;32m[SUCCESS]\033[0m $1"
}

print_error() {
    echo -e "\033[1;31m[ERROR]\033[0m $1" >&2
}

# Check if the OS is macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is intended to run on macOS."
    exit 1
fi

# Determine the script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Function to get Homebrew prefix
get_brew_prefix() {
    if command -v brew &>/dev/null; then
        brew --prefix
    else
        echo "/opt/homebrew"
    fi
}

# Install Homebrew if not already installed
install_homebrew() {
    if ! command -v brew &>/dev/null; then
        print_info "Installing Homebrew for Apple Silicon..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        print_success "Homebrew installed successfully."
        # Add Homebrew to PATH for the current session
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        print_info "Homebrew is already installed. Updating Homebrew..."
        brew update && brew upgrade
        print_success "Homebrew updated successfully."
    fi
}

# Install packages from Brewfile
install_brewfile() {
    if [[ -f "$SCRIPT_DIR/Brewfile" ]]; then
        print_info "Installing packages from Brewfile..."
        brew bundle --file="$SCRIPT_DIR/Brewfile"
        print_success "Packages installed successfully."
    else
        print_error "Brewfile not found in $SCRIPT_DIR."
        exit 1
    fi
}

# Configure macOS system settings
configure_system_settings() {
    print_info "Configuring macOS system settings..."

    # Do NOT show hidden files in Finder
    defaults write com.apple.finder AppleShowAllFiles -bool false

    # Set a fast key repeat rate
    defaults write NSGlobalDomain KeyRepeat -int 1
    defaults write NSGlobalDomain InitialKeyRepeat -int 15

    # Disable screenshot shadow
    defaults write com.apple.screencapture disable-shadow -bool true

    # Auto-hide the Dock
    defaults write com.apple.dock autohide -bool true

    # Enable three finger dragging on the trackpad
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

    # Show all file extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # Apply changes
    killall Finder &>/dev/null || true
    killall Dock &>/dev/null || true
    killall SystemUIServer &>/dev/null || true

    print_success "macOS system settings configured."
}

# Backup existing config files
backup_configs() {
    CONFIG_DIR="$HOME/.config"
    BACKUP_DIR="$HOME/.config_backup_$(date +%s)"

    if [[ -d "$CONFIG_DIR" ]]; then
        print_info "Backing up existing ~/.config to $BACKUP_DIR..."
        mkdir -p "$BACKUP_DIR"
        cp -r "$CONFIG_DIR" "$BACKUP_DIR/"
        print_success "Backup of ~/.config completed."
    fi

    # Backup files in home directory that will be overwritten
    for file in "$SCRIPT_DIR/config_files"/*; do
        filename="$(basename "$file")"
        # Skip .config directory
        if [[ "$filename" == ".config" ]]; then
            continue
        fi
        if [[ -f "$HOME/$filename" || -d "$HOME/$filename" ]]; then
            print_info "Backing up existing ~/$filename to $BACKUP_DIR..."
            mkdir -p "$BACKUP_DIR"
            cp -r "$file" "$BACKUP_DIR/"
            print_success "Backup of ~/$filename completed."
        fi
    done

    # Backup existing .zshrc if it exists
    if [[ -f "$HOME/.zshrc" ]]; then
        print_info "Backing up existing ~/.zshrc to $BACKUP_DIR..."
        mkdir -p "$BACKUP_DIR"
        cp "$HOME/.zshrc" "$BACKUP_DIR/"
        print_success "Backup of ~/.zshrc completed."
    fi
}

# Copy configuration files
copy_config_files() {
    print_info "Copying configuration files..."

    # Ensure .config directory exists
    mkdir -p "$HOME/.config"

    # Copy files to .config
    if [[ -d "$SCRIPT_DIR/config_files/.config" ]]; then
        cp -r "$SCRIPT_DIR/config_files/.config/"* "$HOME/.config/"
        print_success "Copied files to ~/.config."
    else
        print_info "No .config directory found in config_files."
    fi

    # Copy files to home directory
    for file in "$SCRIPT_DIR/config_files"/*; do
        filename="$(basename "$file")"
        # Skip .config directory
        if [[ "$filename" == ".config" ]]; then
            continue
        fi
        cp -r "$file" "$HOME/"
        print_success "Copied $filename to home directory."
    done

    print_success "Configuration files copied."
}

# Install Oh My Zsh
install_oh_my_zsh() {
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        print_info "Oh My Zsh is already installed."
    else
        print_info "Installing Oh My Zsh..."
        # Backup existing .zshrc if not already backed up
        if [[ -f "$HOME/.zshrc" ]]; then
            BACKUP_ZSHRC="$HOME/.zshrc_backup_$(date +%s)"
            print_info "Backing up existing ~/.zshrc to $BACKUP_ZSHRC..."
            cp "$HOME/.zshrc" "$BACKUP_ZSHRC"
            print_success "Backup of ~/.zshrc completed."
        fi

        # Install Oh My Zsh without changing the shell or running Zsh immediately
        RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        print_success "Oh My Zsh installed successfully."

        # Replace .zshrc with the one from config_files (if exists)
        if [[ -f "$SCRIPT_DIR/config_files/.zshrc" ]]; then
            cp "$SCRIPT_DIR/config_files/.zshrc" "$HOME/.zshrc"
            print_success "Replaced ~/.zshrc with custom configuration."
        else
            print_info "No custom .zshrc found in config_files."
        fi
    fi
}

# Install Zsh Plugins and Themes via Brew
install_zsh_plugins() {
    BREW_PREFIX=$(get_brew_prefix)
    print_info "Installing Zsh plugins and themes..."

    # Install zsh-syntax-highlighting
    if [[ -d "$BREW_PREFIX/share/zsh-syntax-highlighting" ]]; then
        print_info "zsh-syntax-highlighting is already installed."
    else
        print_info "Installing zsh-syntax-highlighting..."
        brew install zsh-syntax-highlighting
        print_success "zsh-syntax-highlighting installed successfully."
    fi

    # Install zsh-autosuggestions
    if [[ -d "$BREW_PREFIX/share/zsh-autosuggestions" ]]; then
        print_info "zsh-autosuggestions is already installed."
    else
        print_info "Installing zsh-autosuggestions..."
        brew install zsh-autosuggestions
        print_success "zsh-autosuggestions installed successfully."
    fi

    # Install powerlevel10k (optional)
    if [[ -d "$BREW_PREFIX/opt/powerlevel10k" ]]; then
        print_info "powerlevel10k is already installed."
    else
        print_info "Installing powerlevel10k..."
        brew install romkatv/powerlevel10k/powerlevel10k
        print_success "powerlevel10k installed successfully."
    fi
}

# Configure Oh My Zsh Plugins and Themes
configure_oh_my_zsh() {
    print_info "Configuring Oh My Zsh plugins and themes..."

    BREW_PREFIX=$(get_brew_prefix)

    # Ensure the custom .zshrc sources plugins correctly
    if [[ -f "$HOME/.zshrc" ]]; then
        # Add plugins to .zshrc if not already present
        if ! grep -q "zsh-syntax-highlighting" "$HOME/.zshrc"; then
            sed -i '' 's/^plugins=(/plugins=(git zsh-syntax-highlighting zsh-autosuggestions /' "$HOME/.zshrc"
            print_success "Added zsh-syntax-highlighting and zsh-autosuggestions to plugins."
        fi

        # Set theme to powerlevel10k if desired
        if grep -q "^ZSH_THEME=" "$HOME/.zshrc"; then
            sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$HOME/.zshrc"
            print_success "Set ZSH_THEME to powerlevel10k."
        else
            echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> "$HOME/.zshrc"
            print_success "Set ZSH_THEME to powerlevel10k."
        fi

        # Source plugins with dynamic brew prefix
        sed -i '' "s|zsh-syntax-highlighting.zsh|$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh|" "$HOME/.zshrc"
        sed -i '' "s|zsh-autosuggestions.zsh|$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh|" "$HOME/.zshrc"
        sed -i '' "s|powerlevel10k.zsh-theme|$BREW_PREFIX/opt/powerlevel10k/share/zsh-theme/powerlevel10k.zsh-theme|" "$HOME/.zshrc"

        print_success "Oh My Zsh configured with plugins and themes."
    else
        print_error "~/.zshrc not found. Ensure Oh My Zsh was installed correctly."
        exit 1
    fi
}

# Main execution flow
main() {
    install_homebrew
    install_brewfile
    configure_system_settings
    backup_configs
    copy_config_files
    install_oh_my_zsh
    install_zsh_plugins
    configure_oh_my_zsh
    print_success "Setup complete! Some changes may require you to log out and log back in."
}

# Execute main function
main
