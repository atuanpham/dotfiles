# Dotfiles

This repository contains my personal dotfiles for setting up a unified development environment on macOS and Ubuntu.

## What's Included

- **bash**: Configuration with aliases, functions, and cross-platform setup.
- **git**: Common git configurations and aliases.
- **nvim**: Neovim setup using lazy.nvim (LSP, treesitter, telescope, DAP).
- **tmux**: Tmux configuration with sensible pane navigation and TPM.
- **bin**: Custom utility scripts (e.g., `update-dotfiles`, `create-cpp-project`).

## Supported Platforms

- macOS
- Ubuntu 22.04+

## Prerequisites

- `git`
- `curl`

Everything else (including Homebrew on macOS, stow, nvim, tmux, ripgrep, fonts, etc.) is installed automatically by the setup script.

## Installation

Run the following one-line command to install everything:

```bash
git clone https://github.com/atuanpham/dotfiles.git ~/.dotfiles && cd ~/.dotfiles && ./install.sh
```

### Options

```
./install.sh --help         # Show instructions
./install.sh --force        # Overwrite existing files (restow)
./install.sh --skip-packages # Skip brew/apt package installation
./install.sh --skip-stow    # Skip symlinking via stow
```

## Post-Install Steps

After installation, complete the following steps to initialize plugins:

1. **Tmux Plugins:**
   Open tmux by running `tmux`. Then press `Ctrl+b` followed by `I` (capital i) to install TPM plugins (tmux-sensible, tmux-yank).
2. **Neovim Plugins:**
   Launch Neovim by running `nvim`. The `lazy.nvim` package manager will automatically download and install all configured plugins.

## How to Add a New Config

To add configuration for a new tool (e.g., `htop`):

1. Create a new directory in the repo matching the tool name: `mkdir -p htop/.config/htop`
2. Place config files inside, mirroring the structure in `$HOME`: `cp ~/.config/htop/htoprc htop/.config/htop/`
3. Run stow: `stow htop` (or add it to the package list in `install.sh`).

## Updating

To pull the latest changes and update your environment, run:

```bash
update-dotfiles
```

This utility script is automatically installed to `$HOME/bin`.

## Uninstall

To remove all symlinks created by this repository:

```bash
./uninstall.sh
```

Optionally remove installed packages with `./uninstall.sh --remove-packages`.

## Key Bindings

### Tmux (Prefix: `Ctrl+b`)
- `Ctrl+b` + `|`: Split pane vertically
- `Ctrl+b` + `-`: Split pane horizontally
- `Ctrl+h/j/k/l`: Navigate panes (left/down/up/right)
- `Ctrl+b` + `[`: Enter copy mode (Vi-mode enabled: `v` to select, `y` to yank to system clipboard)
- `Ctrl+b` + `I`: Install plugins via TPM

### Neovim (Leader: `Space`)
*Note: Refer to `nvim/.config/nvim/lua/config/keymaps.lua` and specific plugin configs for full details.*
- `Space` + `e`: Open neo-tree (file explorer)
- `Space` + `ff`: Find files (Telescope)
- `Space` + `fg`: Live grep (Telescope)
- `Ctrl+h/j/k/l`: Navigate windows (left/down/up/right)

## License

Do whatever the fuck you want. I don't care.
