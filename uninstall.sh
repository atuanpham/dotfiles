#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${DOTFILES_DIR}/scripts/helpers.sh"

# Parse command line arguments
REMOVE_PACKAGES=false
RESTORE_BACKUPS=true

print_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -h, --help             Show this help message"
    echo "  --remove-packages      Also remove installed packages (dangerous)"
    echo "  --no-restore           Don't restore backups of original files"
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
        --no-restore)
            RESTORE_BACKUPS=false
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

# List of symlinks to remove
files=(
    "$HOME/.bashrc"
    "$HOME/.bash/aliases"
    "$HOME/.bash/prompt"
    "$HOME/.bash/exports"
    "$HOME/.bash/functions"
    "$HOME/.gitconfig"
    "$HOME/.gitignore_global"
    "$HOME/.clang-format"
)

# VS Code config paths
if [[ "$OSTYPE" == "darwin"* ]]; then
    VSCODE_CONFIG_DIR="$HOME/Library/Application Support/Code/User"
else
    VSCODE_CONFIG_DIR="$HOME/.config/Code/User"
fi

files+=("$VSCODE_CONFIG_DIR/settings.json")
files+=("$VSCODE_CONFIG_DIR/keybindings.json")

# Remove symlinks
for file in "${files[@]}"; do
    if [[ -L "$file" ]]; then
        info "Removing symlink: $file"
        rm "$file"
        success "Removed symlink: $file"
    fi
done

# Remove source line from .bash_profile
if grep -q 'source "$HOME/.bashrc"' "$HOME/.bash_profile"; then
    info "Removing source line from .bash_profile"
    grep -v 'source "$HOME/.bashrc"' "$HOME/.bash_profile" > "$HOME/.bash_profile.tmp"
    mv "$HOME/.bash_profile.tmp" "$HOME/.bash_profile"
    success "Removed source line from .bash_profile"
fi

# Restore backups if requested
if [[ "$RESTORE_BACKUPS" == "true" ]]; then
    header "Restoring backups"
    
    # Find the most recent backup directory
    backup_dir=$(find "$HOME/.dotfiles_backup" -maxdepth 1 -type d | sort -r | head -n 1)
    
    if [[ -d "$backup_dir" ]]; then
        info "Restoring from backup: $backup_dir"
        
        # Restore each backed up file
        for file in "$backup_dir"/*; do
            if [[ -f "$file" ]]; then
                dest="$HOME/$(basename "$file")"
                info "Restoring: $dest"
                cp "$file" "$dest"
                success "Restored: $dest"
            fi
        done
    else
        warning "No backup directory found"
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
        if command_exists brew; then
            info "Uninstalling Homebrew packages"
            brew bundle cleanup --force --file="${DOTFILES_DIR}/packages/brew/Brewfile.base"
            brew bundle cleanup --force --file="${DOTFILES_DIR}/packages/brew/Brewfile.dev"
            brew bundle cleanup --force --file="${DOTFILES_DIR}/packages/brew/Brewfile.apps"
        fi
    else
        info "Skipping package removal"
    fi
fi

success "Uninstallation complete!"