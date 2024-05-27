#!/bin/bash

DOTFILES_DIR_PATH=`dirname "$BASH_SOURCE"`
BASH_DIR=${HOME}/.bash

# Check OS
if [[ "${OSTYPE}" != "darwin"* ]]; then
    echo "This script only support MacOS system."
    exit 1
fi

# Array of VSCode extensions to install
vscode_extensions=(
    vscodevim.vim
    ms-python.python
    eamodio.gitlens
    visualstudioexptteam.vscodeintellicode
    formulahendry.code-runner
)

install_vscode_extensions() {
    for extension in "$@"; do
        code --install-extension "$extension"
    done
}

setup_bash_profile() {
    # Set up bash configuration files
    mkdir -p ~/.bash
    echo "Setting up bash scripts"

    # Create symlinks for bash configuration files
    ln -sf "${DOTFILES_DIR_PATH}/bash/bash_profile" "${HOME}/.bash_profile"
    ln -sf "${DOTFILES_DIR_PATH}/bash/aliases" "${HOME}/.bash/aliases"
    ln -sf "${DOTFILES_DIR_PATH}/bash/prompt" "${HOME}/.bash/prompt"
    ln -sf "${DOTFILES_DIR_PATH}/bash/exports" "${HOME}/.bash/exports"
    ln -sf "${DOTFILES_DIR_PATH}/bash/functions" "${HOME}/.bash/functions"
}

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> $HOME/.bash_profile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Update Homebrew and upgrade existing packages
brew update
brew upgrade

brew bundle cleanup
brew bundle -v --force --file="${DOTFILES_DIR_PATH}/Brewfile"

# Install VSCode extensions
install_vscode_extensions "${vscode_extensions[@]}"

# Initialize Conda
conda init bash
source ~/.bash_profile

# Create a Python development environment
conda create -n pydev python=3 -y
conda activate pydev

# Install Python packages
conda install -c conda-forge black isort pylint -y

# Symlink VSCode configuration files
VSCODE_CONFIG_DIR="$HOME/Library/Application Support/Code/User"
ln -sf "${DOTFILES_DIR_PATH}/vscode/settings.json" "$VSCODE_CONFIG_DIR/settings.json"
ln -sf "${DOTFILES_DIR_PATH}/vscode/keybindings.json" "$VSCODE_CONFIG_DIR/keybindings.json"

echo "Dotfiles setup complete!"
