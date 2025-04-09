#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${DOTFILES_DIR}/scripts/helpers.sh"

SKIP_PACKAGES=false
SKIP_SYMLINKS=false
FORCE=false

print_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -h, --help         Show this help message"
    echo "  -f, --force        Force overwrite of existing files"
    echo "  --skip-packages    Skip package installation"
    echo "  --skip-symlinks    Skip symlink creation"
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
        --skip-symlinks)
            SKIP_SYMLINKS=true
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
    OS="linux"
fi

header "Setting up dotfiles for $OS"

# Create necessary directories
mkdir -p "$HOME/.bash" "$HOME/bin"

# Platform-specific setup
if [[ "$OS" == "macos" ]]; then
    info "Running macOS-specific setup"
    source "${DOTFILES_DIR}/scripts/macos.sh"
elif [[ "$OS" == "linux" ]]; then
    info "Running Linux-specific setup"
    # Placeholder for future Linux implementation
    warning "Linux setup is not fully implemented yet"
else
    error "Unsupported OS: $OSTYPE"
    exit 1
fi

# Create common symlinks (platform-independent)
if [[ "$SKIP_SYMLINKS" == "false" ]]; then
    info "Creating symlinks"
    source "${DOTFILES_DIR}/scripts/common.sh"
fi

success "Dotfiles installation complete!"
echo "Log out and log back in to see all changes take effect."