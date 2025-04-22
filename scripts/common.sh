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
link_file "${DOTFILES_DIR}/config/git/gitconfig.local" "$HOME/.gitconfig.local"

if [[ ! -f "$HOME/.gitconfig" ]] || ! grep -q "path = ~/.gitconfig.local" "$HOME/.gitconfig"; then
    info "Creating main .gitconfig with include directive"
    cat > "$HOME/.gitconfig" << EOF
[include]
    path = ~/.gitconfig.local
EOF
    success "Created ~/.gitconfig with include directive"
else
    info "Main .gitconfig with include directive already exists"
fi

# VS Code configuration
header "Setting up VS Code configuration"
VSCODE_CONFIG_DIR="$HOME/Library/Application Support/Code/User"
if [[ "$OS" == "linux" ]]; then
    VSCODE_CONFIG_DIR="$HOME/.config/Code/User"
fi

mkdir -p "$VSCODE_CONFIG_DIR"
link_file "${DOTFILES_DIR}/config/vscode/settings.json" "$VSCODE_CONFIG_DIR/settings.json"
link_file "${DOTFILES_DIR}/config/vscode/keybindings.json" "$VSCODE_CONFIG_DIR/keybindings.json"
link_file "${DOTFILES_DIR}/config/vscode/tasks.json" "$VSCODE_CONFIG_DIR/tasks.json"
link_file "${DOTFILES_DIR}/config/vscode/launch.json" "$VSCODE_CONFIG_DIR/launch.json"
link_file "${DOTFILES_DIR}/config/vscode/c_cpp_properties.json" "$VSCODE_CONFIG_DIR/c_cpp_properties.json"

# Create snippets directory if it doesn't exist
VSCODE_SNIPPETS_DIR="$VSCODE_CONFIG_DIR/snippets"
mkdir -p "$VSCODE_SNIPPETS_DIR"
link_file "${DOTFILES_DIR}/config/vscode/cpp.code-snippets" "$VSCODE_CONFIG_DIR/cpp.code-snippets"

# C/C++ Configuration
header "Setting up C/C++ Configuration"
link_file "${DOTFILES_DIR}/config/clang/.clang-format" "$HOME/.clang-format"
link_file "${DOTFILES_DIR}/config/clang/.clang-tidy" "$HOME/.clang-tidy"

# Create C++ templates
mkdir -p "$HOME/Templates/cpp"
link_file "${DOTFILES_DIR}/config/cpp/CMakeLists.txt.template" "$HOME/Templates/cpp/CMakeLists.txt"

# Bin directory setup
header "Setting up bin directory"
for script in "${DOTFILES_DIR}"/bin/*; do
    if [[ -f "$script" && -x "$script" ]]; then
        link_file "$script" "$HOME/bin/$(basename "$script")"
    fi
done

success "Common configuration complete"
