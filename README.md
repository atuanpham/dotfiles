# Dotfiles

This repository contains my personal dotfiles.

## Setup

1. Clone this repository to your home directory:
   ```
   git clone https://github.com/atuanpham/dotfiles.git ~/dotfiles
   ```

2. Run the setup script:
   ```
   cd ~/dotfiles
   ./setup.sh
   ```

- The setup script assumes you are running macOS and have access to the command line.
- The Python development environment is named `pydev` and uses the latest Python version. You can modify the environment name and Python version in the `setup.sh` script.
- If you encounter any issues during the setup process, please refer to the VSCode documentation or open an issue in this repository.

## Customization

Feel free to customize the `settings.json` and `keybindings.json` files in the `vscode` directory to suit your preferences. The changes will be reflected the next time you start VSCode.