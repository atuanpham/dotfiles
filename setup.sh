#!/bin/bash

DOTFILES_DIR_PATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BASH_DIR=${HOME}/.bash

# Currently, I'm using MacOS only.
# Therefore, this script just works fine in MacOS.
if [[ "${OSTYPE}" != "darwin"* ]]; then
    echo "This script only support MacOS system."
    exit 1
fi

# Array of VSCode extensions to install
vscode_extensions=(
    vscodevim.vim
    ms-python.python
    ms-python.pylint
    ms-python.flake8
    ms-python.debugpy
    ms-python.mypy
    ms-python.vscode-pylance
    ms-python.isort
    ms-vscode.cmake-tools
    ms-vscode.cpptools
    ms-vscode.cpptools-extension-pack
    ms-vscode.cpptools-themes
    ms-vscode.makefile-tools
    eamodio.gitlens
    tamasfe.even-better-toml
    visualstudioexptteam.vscodeintellicode
    formulahendry.code-runner
    njpwerner.autodocstring
    wheredoesyourmindgo.gruvbox-concoctis
    arcticicestudio.nord-visual-studio-code
    # Add C++ related extensions
    twxs.cmake
    ms-vscode.cmake-tools
    xaver.clang-format
    jeff-hykin.better-cpp-syntax
    cschlosser.doxdocgen
)

install_vscode_extensions() {
    for extension in "$@"; do
        code --install-extension "$extension"
        cursor --install-extension "$extension"
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

# After brew bundle section, add:
# Set up LLVM and GCC
echo 'export PATH="/usr/local/opt/llvm/bin:$PATH"' >> ~/.bash_profile
echo 'export LDFLAGS="-L/usr/local/opt/llvm/lib"' >> ~/.bash_profile
echo 'export CPPFLAGS="-I/usr/local/opt/llvm/include"' >> ~/.bash_profile

# Create default .clang-format file in home directory
cat > ~/.clang-format << EOL
---
BasedOnStyle: Google
IndentWidth: 4
ColumnLimit: 100
AccessModifierOffset: -4
NamespaceIndentation: None
FixNamespaceComments: true
EOL

# Create a directory for C++ project templates
mkdir -p ~/cpp_templates
cat > ~/cpp_templates/CMakeLists.txt << EOL
cmake_minimum_required(VERSION 3.15)
project(cpp_project)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_executable(\${PROJECT_NAME} main.cpp)
EOL

cat > ~/cpp_templates/main.cpp << EOL
#include <iostream>

int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}
EOL

# Install VSCode extensions
install_vscode_extensions "${vscode_extensions[@]}"

# Initialize Conda only if not already initialized
if ! grep -q "conda initialize" ~/.bash_profile; then
    conda init bash
    source ~/.bash_profile
fi

# Install Python packages only if not already installed
if ! conda list | grep -q "black"; then
    conda activate base
    conda install -c conda-forge black isort pylint -y
fi

# Add LLVM paths only if not already present
if ! grep -q "LLVM paths" ~/.bash_profile; then
    echo -e "\n# LLVM paths" >> ~/.bash_profile
    echo 'export PATH="/usr/local/opt/llvm/bin:$PATH"' >> ~/.bash_profile
    echo 'export LDFLAGS="-L/usr/local/opt/llvm/lib"' >> ~/.bash_profile
    echo 'export CPPFLAGS="-I/usr/local/opt/llvm/include"' >> ~/.bash_profile
fi

# Symlink VSCode configuration files
VSCODE_CONFIG_DIR="$HOME/Library/Application Support/Code/User"
CURSOR_CONFIG_DIR="$HOME/Library/Application Support/Cursor/User"

# Create Cursor config directory if it doesn't exist and Cursor is installed
if [ -d "/Applications/Cursor.app" ]; then
    mkdir -p "$CURSOR_CONFIG_DIR"
    ln -sf "${DOTFILES_DIR_PATH}"/vscode/settings.json "$CURSOR_CONFIG_DIR"/settings.json
    ln -sf "${DOTFILES_DIR_PATH}"/vscode/keybindings.json "$CURSOR_CONFIG_DIR"/keybindings.json
fi

# Symlink VSCode configuration files
ln -sf "${DOTFILES_DIR_PATH}"/vscode/settings.json "$VSCODE_CONFIG_DIR"/settings.json
ln -sf "${DOTFILES_DIR_PATH}"/vscode/keybindings.json "$VSCODE_CONFIG_DIR"/keybindings.json

echo "Dotfiles setup complete!"
