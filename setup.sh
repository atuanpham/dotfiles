#!/bin/bash

BASH_DIR=${HOME}/.bash

# Check OS
if [[ "${OSTYPE}" != "darwin"* ]]; then
    echo "This script only support MacOS system."
    exit 1
fi

# Set up bash configuration files
mkdir -p ~/.bash
echo "Setting up bash scripts"

# Create symlinks for bash configuration files
ln -sf "${HOME}/dotfiles/bash/bash_profile" "${HOME}/.bash_profile"
ln -sf "${HOME}/dotfiles/bash/aliases" "${HOME}/.bash/aliases"
ln -sf "${HOME}/dotfiles/bash/prompt" "${HOME}/.bash/prompt"
ln -sf "${HOME}/dotfiles/bash/exports" "${HOME}/.bash/exports"
ln -sf "${HOME}/dotfiles/bash/functions" "${HOME}/.bash/functions"

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> $HOME/.bash_profile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

brew install coreutils

# Install VSCode using Homebrew
brew install --cask visual-studio-code

# Install VSCode extensions
code --install-extension vscodevim.vim
code --install-extension ms-python.python
code --install-extension eamodio.gitlens
code --install-extension visualstudioexptteam.vscodeintellicode
code --install-extension formulahendry.code-runner

# Install Miniconda
brew install miniconda

# Set up Miniconda
conda init bash
source ~/.bash_profile

# Create a Python development environment
conda create -n pydev python=3 -y
conda activate pydev

# Install Python packages
conda install -c conda-forge black isort pylint -y

# Symlink VSCode configuration files
VSCODE_CONFIG_DIR="$HOME/Library/Application Support/Code/User"
ln -sf "$HOME/dotfiles/vscode/settings.json" "$VSCODE_CONFIG_DIR/settings.json"
ln -sf "$HOME/dotfiles/vscode/keybindings.json" "$VSCODE_CONFIG_DIR/keybindings.json"

echo "VSCode and Miniconda setup complete!"
