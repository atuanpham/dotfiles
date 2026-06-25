#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${DOTFILES_DIR}/scripts/helpers.sh"

# Parse command line arguments
REMOVE_PACKAGES=false

print_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -h, --help             Show this help message"
    echo "  --remove-packages      Also remove installed packages (dangerous)"
}

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -h|--help)
            print_usage
            exit 0
            ;;
        --remove-packages)
            REMOVE_PACKAGES=true
            shift
            ;;
        *)
            echo "Unknown option: $key"
            print_usage
            exit 1
            ;;
    esac
done

header "Uninstalling dotfiles"

info "Removing stow symlinks"
cd "${DOTFILES_DIR}"
stow -D bash git nvim tmux clang bin cpp-templates
cd - >/dev/null
success "Removed stow symlinks"

# Handle .gitconfig specially
if [[ -f "$HOME/.gitconfig" ]]; then
    info "Checking .gitconfig file"
    if grep -q "path = ~/.gitconfig.local" "$HOME/.gitconfig"; then
        info "Removing include directive from .gitconfig"
        # Create a temporary file and filter out the include section
        sed -i.bak '/\[include\]/d; /path = ~\/.gitconfig.local/d' "$HOME/.gitconfig"
        rm -f "$HOME/.gitconfig.bak"
        success "Removed include directive from .gitconfig"
    fi
fi

# Remove packages if requested
if [[ "$REMOVE_PACKAGES" == "true" ]]; then
    header "Warning: Removing packages"
    warning "This will attempt to uninstall all packages installed by the dotfiles setup"
    warning "This action cannot be undone and may break your system"

    # Ask for confirmation
    read -p "Are you sure you want to continue? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [[ "$OSTYPE" == "darwin"* ]] && command_exists brew; then
            info "Uninstalling Homebrew packages"
            brew bundle cleanup --force --file="${DOTFILES_DIR}/packages/brew/Brewfile"
        else
            warning "Package removal only implemented for Homebrew on macOS"
        fi
    else
        info "Skipping package removal"
    fi
fi

success "Uninstallation complete!"
