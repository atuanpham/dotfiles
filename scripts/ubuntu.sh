#!/usr/bin/env bash

# Source helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
source "${SCRIPT_DIR}/helpers.sh"

header "Setting up Ubuntu"

# Require sudo privileges
info "Requesting sudo privileges..."
sudo -v || { error "Sudo privileges required."; exit 1; }

header "Updating APT packages"
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -y
sudo apt-get upgrade -y

header "Installing APT packages"
PACKAGES_FILE="${DOTFILES_DIR}/packages/apt/packages.txt"
if [[ -f "$PACKAGES_FILE" ]]; then
    # Read packages from file, ignoring comments and empty lines
    PACKAGES=$(grep -vE '^\s*#|^\s*$' "$PACKAGES_FILE" | tr '\n' ' ')
    if [[ -n "$PACKAGES" ]]; then
        info "Installing packages..."
        # shellcheck disable=SC2086
        sudo apt-get install -y $PACKAGES
        success "APT packages installed"
    else
        warning "No packages found in $PACKAGES_FILE"
    fi
else
    error "Packages file not found: $PACKAGES_FILE"
    exit 1
fi

header "Installing Nerd Fonts"
FONT_DIR="${HOME}/.local/share/fonts"
if [[ ! -d "$FONT_DIR" ]]; then
    mkdir -p "$FONT_DIR"
fi

if command -v fc-list >/dev/null 2>&1 && fc-list | grep -qi "JetBrainsMono Nerd Font"; then
    info "JetBrainsMono Nerd Font already installed"
else
    info "Downloading JetBrainsMono Nerd Font..."
    FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    TMP_DIR=$(mktemp -d)

    if curl -fsSL "$FONT_URL" -o "${TMP_DIR}/JetBrainsMono.zip"; then
        unzip -q "${TMP_DIR}/JetBrainsMono.zip" -d "${TMP_DIR}"
        # Copy only font files, ignoring Windows executables, etc.
        cp "${TMP_DIR}"/*.ttf "$FONT_DIR/"

        info "Updating font cache..."
        if command -v fc-cache >/dev/null 2>&1; then
            fc-cache -f "$FONT_DIR"
        else
            warning "fc-cache not found, font cache not updated. Please install fontconfig."
        fi
        success "JetBrainsMono Nerd Font installed"
    else
        error "Failed to download fonts"
    fi
    rm -rf "$TMP_DIR"
fi

header "Installing NVM (Node Version Manager)"
if [ -d "${HOME}/.nvm" ]; then
    info "NVM is already installed"
else
    info "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    success "NVM installed"
fi

success "Ubuntu setup complete!"
