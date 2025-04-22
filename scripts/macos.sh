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

    # Install core packages
    info "Installing core packages"
    run_command "brew bundle --file=${DOTFILES_DIR}/packages/brew/Brewfile.base"

    # Install development packages
    info "Installing development packages"
    run_command "brew bundle --file=${DOTFILES_DIR}/packages/brew/Brewfile.dev"

    # Install GUI applications
    info "Installing applications"
    run_command "brew bundle --file=${DOTFILES_DIR}/packages/brew/Brewfile.apps"

    # Install VSCode extensions
    if command_exists code; then
        header "Installing VSCode extensions"

        # Get list of currently installed extensions
        installed_extensions=$(code --list-extensions)

        # Install extensions
        while IFS= read -r extension || [[ -n "$extension" ]]; do
            # Skip comments and empty lines
            [[ "$extension" =~ ^#.* || -z "$extension" ]] && continue
            info "Installing VS Code extension: $extension"
            run_command "code --install-extension $extension" "Failed to install extension: $extension"
        done < "${DOTFILES_DIR}/packages/vscode/extensions.txt"

        header "Cleaning up unused VSCode extensions"
        extensions_to_keep=$(grep -v "^#" "${DOTFILES_DIR}/packages/vscode/extensions.txt" | grep -v "^$")

        for ext in $installed_extensions; do
            if ! echo "$extensions_to_keep" | grep -q "$ext"; then
                info "Removing extension not in extensions.txt: $ext"
                run_command "code --uninstall-extension $ext" "Failed to uninstall extension: $ext"
            fi
        done
    else
        warning "VS Code not found, skipping extension installation"
    fi
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

# Configure Conda
if ! command_exists conda; then
    error "Conda has not been installed!"
    return 1
fi

if ! grep -q "conda initialize" "$HOME/.bash_profile"; then
    header "Setting up Conda"
    conda init bash
    source "$HOME/.bash_profile"

    # Install Python packages
    info "Installing Python packages"
    conda activate base
    conda install -c conda-forge black isort pylint mypy -y
    success "Conda configured"
else
    info "Conda already configured"
fi
