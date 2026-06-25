#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${DOTFILES_DIR}/scripts/helpers.sh"

SKIP_PACKAGES=false
SKIP_STOW=false
FORCE=false

print_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -h, --help         Show this help message"
    echo "  -f, --force        Force overwrite of existing files"
    echo "  --skip-packages    Skip package installation"
    echo "  --skip-stow        Skip symlink creation via stow"
}

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -h|--help)
            print_usage
            exit 0
            ;;
        -f|--force)
            FORCE=true
            shift
            ;;
        --skip-packages)
            SKIP_PACKAGES=true
            shift
            ;;
        --skip-stow)
            SKIP_STOW=true
            shift
            ;;
        *)
            echo "Unknown option: $key"
            print_usage
            exit 1
            ;;
    esac
done

# Detect platform
OS="unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="ubuntu"
fi

header "Setting up dotfiles for $OS"

# Platform-specific setup
if [[ "$SKIP_PACKAGES" == "false" ]]; then
    if [[ "$OS" == "macos" ]]; then
        info "Running macOS-specific package setup"
        source "${DOTFILES_DIR}/scripts/macos.sh"
    elif [[ "$OS" == "ubuntu" ]]; then
        info "Running Ubuntu-specific package setup"
        source "${DOTFILES_DIR}/scripts/ubuntu.sh"
    else
        error "Unsupported OS: $OSTYPE"
        exit 1
    fi
fi

# Stow packages
if [[ "$SKIP_STOW" == "false" ]]; then
    info "Stowing packages"
    STOW_CMD="stow"
    if [[ "$FORCE" == "true" ]]; then
        STOW_CMD="stow --adopt --restow"
    fi
    cd "${DOTFILES_DIR}"
    $STOW_CMD bash git nvim tmux clang bin cpp-templates
    cd - >/dev/null
    success "Packages stowed successfully"
fi

# Set up git config
info "Setting up git config"
if [[ ! -f "$HOME/.gitconfig" ]] || ! grep -q "path = ~/.gitconfig.local" "$HOME/.gitconfig"; then
    echo "[include]" >> "$HOME/.gitconfig"
    echo "    path = ~/.gitconfig.local" >> "$HOME/.gitconfig"
    success "Added include directive to ~/.gitconfig"
else
    info "~/.gitconfig already includes ~/.gitconfig.local"
fi

# Bootstrap TPM
info "Bootstrapping TPM"
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    success "TPM cloned to ~/.tmux/plugins/tpm"
else
    info "TPM already installed"
fi

success "Dotfiles installation complete!"
echo ""
info "Post-install notes:"
echo "- Open tmux and press 'prefix + I' (Ctrl+b, then Shift+i) to install tmux plugins."
echo "- Open nvim to let lazy.nvim install Neovim plugins."
echo "- Log out and log back in to see all changes take effect."
