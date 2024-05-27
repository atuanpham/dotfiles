# Dotfiles

This repository contains my personal dotfiles for setting up a development environment on MacOS, optimized for Python development with Vim keybindings in Visual Studio Code (VSCode).

## Prerequisites

- It just works fine on MacOS.

## Setup

To set up the development environment with these configurations, follow these steps:

1. Clone this repository to your desired location:
   ```
   git clone https://github.com/atuanpham/dotfiles.git
   ```

2. Navigate to the cloned repository:
   ```
   cd dotfiles
   ```

3. Run the setup script:
   ```
   chmod +x setup.py
   ./setup.sh
   ```

The setup script will:
- Install Homebrew (if not already installed)
- Update and upgrade existing Homebrew packages
- Install packages and casks specified in the `Brewfile`
- Install VSCode extensions for Python development and Vim keybindings
- Set up bash configuration files by symlinking them to the home directory
- Initialize Conda and create a Python development environment
- Symlink VSCode configuration files to the appropriate directory

## Customization

### Bash Configuration

The bash configuration files are located in the `bash` directory. You can customize the following files according to your preferences:
- `aliases`: Define your custom aliases
- `prompt`: Customize your bash prompt
- `exports`: Set environment variables
- `functions`: Define custom functions

### VSCode Configuration

The VSCode configuration files are located in the `vscode` directory. You can customize the following files:
- `settings.json`: Modify VSCode settings
- `keybindings.json`: Customize keyboard shortcuts

### Brewfile

The `Brewfile` contains a list of packages and casks to be installed via Homebrew. You can add or remove packages based on your requirements.

### VSCode Extensions

The list of VSCode extensions to be installed is defined in the `vscode_extensions` array in the `setup.sh` script. You can modify this array to include additional extensions or remove unnecessary ones.

## Additional Notes

- The setup script assumes you are running MacOS and have access to the command line.
- The Python development environment is set up using Conda, and the default environment is activated.
- If you encounter any issues during the setup process, please refer to the respective documentation or open an issue in this repository.

Happy coding!