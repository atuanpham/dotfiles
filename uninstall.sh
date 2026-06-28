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
stow -D bash git nvim tmux clang bin cpp-templates kanata
cd - >/dev/null
success "Removed stow symlinks"

# Stop and disable Kanata service
info "Removing Kanata service"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if systemctl --user is-enabled kanata.service &>/dev/null; then
        systemctl --user stop kanata.service 2>/dev/null
        systemctl --user disable kanata.service 2>/dev/null
        rm -f "${HOME}/.config/systemd/user/kanata.service"
        systemctl --user daemon-reload
        success "Kanata systemd service removed"
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    KANATA_PLIST="/Library/LaunchDaemons/com.jtroo.kanata.plist"
    if [[ -f "$KANATA_PLIST" ]]; then
        sudo launchctl bootout system/com.jtroo.kanata 2>/dev/null
        sudo rm -f "$KANATA_PLIST"
        success "Kanata LaunchDaemon removed"
    fi

    KARABINER_PLIST="/Library/LaunchDaemons/org.pqrs.Karabiner-VirtualHIDDevice-Daemon.plist"
    if [[ -f "$KARABINER_PLIST" ]]; then
        sudo launchctl bootout system/org.pqrs.Karabiner-VirtualHIDDevice-Daemon 2>/dev/null
        sudo rm -f "$KARABINER_PLIST"
        success "Karabiner VHIDDevice Daemon removed"
    fi
fi

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
