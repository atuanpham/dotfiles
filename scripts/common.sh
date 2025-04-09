#!/usr/bin/env bash

# Common setup for all platforms

# Create ~/.bash directory if it doesn't exist
mkdir -p "$HOME/.bash"

# Bash configuration
header "Setting up Bash configuration"
link_file "${DOTFILES_DIR}/config/bash/bashrc" "$HOME/.bashrc"
link_file "${DOTFILES_DIR}/config/bash/aliases" "$HOME/.bash/aliases"
link_file "${DOTFILES_DIR}/config/bash/prompt" "$HOME/.bash/prompt"
link_file "${DOTFILES_DIR}/config/bash/exports" "$HOME/.bash/exports"
link_file "${DOTFILES_DIR}/config/bash/functions" "$HOME/.bash/functions"

# Add source line to .bash_profile if not already present
if ! grep -q 'source "$HOME/.bashrc"' "$HOME/.bash_profile" 2>/dev/null; then
    echo 'source "$HOME/.bashrc"' >> "$HOME/.bash_profile"
    success "Added source line to .bash_profile"
else
    info "Source line already in .bash_profile"
fi

# Git configuration
header "Setting up Git configuration"
link_file "${DOTFILES_DIR}/config/git/gitconfig" "$HOME/.gitconfig"
link_file "${DOTFILES_DIR}/config/git/gitignore_global" "$HOME/.gitignore_global"

# VS Code configuration
header "Setting up VS Code configuration"
VSCODE_CONFIG_DIR="$HOME/Library/Application Support/Code/User"
if [[ "$OS" == "linux" ]]; then
    VSCODE_CONFIG_DIR="$HOME/.config/Code/User"
fi

mkdir -p "$VSCODE_CONFIG_DIR"
link_file "${DOTFILES_DIR}/config/vscode/settings.json" "$VSCODE_CONFIG_DIR/settings.json"
link_file "${DOTFILES_DIR}/config/vscode/keybindings.json" "$VSCODE_CONFIG_DIR/keybindings.json"

# Clang format
header "Setting up Clang Format"
link_file "${DOTFILES_DIR}/config/clang/.clang-format" "$HOME/.clang-format"

# Bin directory setup
header "Setting up bin directory"
for script in "${DOTFILES_DIR}"/bin/*; do
    if [[ -f "$script" && -x "$script" ]]; then
        link_file "$script" "$HOME/bin/$(basename "$script")"
    fi
done

success "Common configuration complete"