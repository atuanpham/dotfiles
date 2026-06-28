#!/usr/bin/env bash

# macOS-specific setup

if [ ! -f "$HOME/.bash_profile" ]; then
    touch $HOME/.bash_profile
fi

# Install Homebrew if not already installed
if ! command_exists brew; then
    header "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH based on architecture
    if [[ "$(uname -m)" == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.bash_profile"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> "$HOME/.bash_profile"
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    success "Homebrew installed"
else
    info "Homebrew already installed, updating"
    brew update
fi

# Install packages if not skipped
if [[ "$SKIP_PACKAGES" == "false" ]]; then
    header "Installing packages"

    info "Installing packages from Brewfile"
    run_command "brew bundle --file=${DOTFILES_DIR}/packages/brew/Brewfile"
fi

header "Installing Karabiner DriverKit VirtualHIDDevice"
if [[ -d "/Applications/.Karabiner-VirtualHIDDevice-Manager.app" ]]; then
    info "Karabiner DriverKit VirtualHIDDevice already installed"
else
    KARABINER_DRIVER_VERSION="6.2.0"
    KARABINER_PKG="Karabiner-DriverKit-VirtualHIDDevice-${KARABINER_DRIVER_VERSION}.pkg"
    KARABINER_URL="https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases/download/v${KARABINER_DRIVER_VERSION}/${KARABINER_PKG}"

    TMP_DIR=$(mktemp -d)
    info "Downloading Karabiner DriverKit v${KARABINER_DRIVER_VERSION}..."
    if curl -fsSL "$KARABINER_URL" -o "${TMP_DIR}/${KARABINER_PKG}"; then
        sudo installer -pkg "${TMP_DIR}/${KARABINER_PKG}" -target /
        success "Karabiner DriverKit VirtualHIDDevice installed"
    else
        error "Failed to download Karabiner DriverKit"
    fi
    rm -rf "$TMP_DIR"
fi

# Activate the driver extension
if [[ -f "/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager" ]]; then
    info "Activating Karabiner DriverKit extension..."
    '/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager' activate
    success "Karabiner DriverKit extension activation requested"
    warning "You must approve the driver in System Settings > General > Login Items & Extensions > Driver Extensions"
fi

# Set up LLVM and GCC paths
if ! grep -q "LLVM paths" "$HOME/.bash_profile"; then
    header "Setting up LLVM and GCC paths"
    echo -e "\n# LLVM paths" >> "$HOME/.bash_profile"

    # Check if we're on Apple Silicon
    if [[ "$(uname -m)" == "arm64" ]]; then
        echo 'export PATH="/opt/homebrew/opt/llvm/bin:$PATH"' >> "$HOME/.bash_profile"
        echo 'export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"' >> "$HOME/.bash_profile"
        echo 'export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"' >> "$HOME/.bash_profile"
    else
        echo 'export PATH="/usr/local/opt/llvm/bin:$PATH"' >> "$HOME/.bash_profile"
        echo 'export LDFLAGS="-L/usr/local/opt/llvm/lib"' >> "$HOME/.bash_profile"
        echo 'export CPPFLAGS="-I/usr/local/opt/llvm/include"' >> "$HOME/.bash_profile"
    fi

    success "LLVM paths configured"
else
    info "LLVM paths already configured"
fi

# Bootstrap TPM
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    header "Setting up Tmux Plugin Manager"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    success "TPM installed"
else
    info "TPM already installed"
fi
