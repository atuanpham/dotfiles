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

header "Installing Kanata"
KANATA_BIN="${HOME}/.local/bin/kanata"
if [[ -f "$KANATA_BIN" ]]; then
    info "Kanata already installed at $KANATA_BIN"
else
    info "Downloading Kanata from GitHub releases..."
    mkdir -p "${HOME}/.local/bin"
    TMP_DIR=$(mktemp -d)

    if curl -fsSL "https://github.com/jtroo/kanata/releases/latest/download/linux-binaries-x64.zip" \
        -o "${TMP_DIR}/kanata.zip"; then
        unzip -q "${TMP_DIR}/kanata.zip" -d "${TMP_DIR}"
        cp "${TMP_DIR}/kanata" "$KANATA_BIN"
        chmod +x "$KANATA_BIN"
        success "Kanata installed to $KANATA_BIN"
    else
        error "Failed to download Kanata"
    fi

    rm -rf "$TMP_DIR"
fi

header "Setting up Kanata permissions"

# udev rule for uinput access
UDEV_RULE="/etc/udev/rules.d/99-kanata.rules"
if [[ -f "$UDEV_RULE" ]]; then
    info "Kanata udev rule already exists"
else
    sudo tee "$UDEV_RULE" > /dev/null << 'UDEV_EOF'
KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput"
UDEV_EOF
    sudo udevadm control --reload-rules
    sudo udevadm trigger
    success "Kanata udev rule created"
fi

# Ensure uinput module loads at boot
if [[ ! -f /etc/modules-load.d/kanata.conf ]]; then
    echo "uinput" | sudo tee /etc/modules-load.d/kanata.conf > /dev/null
    sudo modprobe uinput
    success "uinput module configured to load at boot"
fi

# Add user to input group
if groups "$USER" | grep -q '\binput\b'; then
    info "User already in input group"
else
    sudo usermod -aG input "$USER"
    warning "Added $USER to input group -- re-login required for group change to take effect"
fi

success "Ubuntu setup complete!"
