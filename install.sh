#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${DOTFILES_DIR}/scripts/helpers.sh"

SKIP_PACKAGES=false
SKIP_STOW=false
FORCE=false

print_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -h, --help         Show this help message"
    echo "  -f, --force        Force overwrite of existing files"
    echo "  --skip-packages    Skip package installation"
    echo "  --skip-stow        Skip symlink creation via stow"
}

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -h|--help)
            print_usage
            exit 0
            ;;
        -f|--force)
            FORCE=true
            shift
            ;;
        --skip-packages)
            SKIP_PACKAGES=true
            shift
            ;;
        --skip-stow)
            SKIP_STOW=true
            shift
            ;;
        *)
            echo "Unknown option: $key"
            print_usage
            exit 1
            ;;
    esac
done

# Detect platform
OS="unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="ubuntu"
fi

header "Setting up dotfiles for $OS"

# Platform-specific setup
if [[ "$SKIP_PACKAGES" == "false" ]]; then
    if [[ "$OS" == "macos" ]]; then
        info "Running macOS-specific package setup"
        source "${DOTFILES_DIR}/scripts/macos.sh"
    elif [[ "$OS" == "ubuntu" ]]; then
        info "Running Ubuntu-specific package setup"
        source "${DOTFILES_DIR}/scripts/ubuntu.sh"
    else
        error "Unsupported OS: $OSTYPE"
        exit 1
    fi
fi

# Stow packages
if [[ "$SKIP_STOW" == "false" ]]; then
    info "Stowing packages"
    STOW_CMD="stow"
    if [[ "$FORCE" == "true" ]]; then
        STOW_CMD="stow --adopt --restow"
    fi
    cd "${DOTFILES_DIR}"
    $STOW_CMD bash git nvim tmux clang bin cpp-templates kanata
    cd - >/dev/null
    success "Packages stowed successfully"
fi

# Set up git config
info "Setting up git config"
if [[ ! -f "$HOME/.gitconfig" ]] || ! grep -q "path = ~/.gitconfig.local" "$HOME/.gitconfig"; then
    echo "[include]" >> "$HOME/.gitconfig"
    echo "    path = ~/.gitconfig.local" >> "$HOME/.gitconfig"
    success "Added include directive to ~/.gitconfig"
else
    info "~/.gitconfig already includes ~/.gitconfig.local"
fi

# Bootstrap TPM
info "Bootstrapping TPM"
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    success "TPM cloned to ~/.tmux/plugins/tpm"
else
    info "TPM already installed"
fi

# Set up Kanata auto-start
info "Setting up Kanata service"
if [[ "$OS" == "ubuntu" ]]; then
    KANATA_SERVICE_DIR="${HOME}/.config/systemd/user"
    mkdir -p "$KANATA_SERVICE_DIR"
    cat > "${KANATA_SERVICE_DIR}/kanata.service" << 'EOF'
[Unit]
Description=Kanata keyboard remapper
Documentation=https://github.com/jtroo/kanata

[Service]
Type=simple
ExecStart=%h/.local/bin/kanata --cfg %h/.config/kanata/kanata.kbd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=default.target
EOF
    systemctl --user daemon-reload
    systemctl --user enable kanata.service
    success "Kanata systemd user service enabled (starts on next login)"
elif [[ "$OS" == "macos" ]]; then
    # Kanata needs root on macOS to communicate with the Karabiner driver,
    # so both daemons go in /Library/LaunchDaemons (system-level).

    KANATA_LOG_DIR="${HOME}/.local/share/kanata"
    mkdir -p "$KANATA_LOG_DIR"

    # 1) Karabiner VHIDDevice Daemon -- bridges kanata <-> driver
    KARABINER_PLIST="/Library/LaunchDaemons/org.pqrs.Karabiner-VirtualHIDDevice-Daemon.plist"
    if [[ ! -f "$KARABINER_PLIST" ]]; then
        sudo tee "$KARABINER_PLIST" > /dev/null << 'KEOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>org.pqrs.Karabiner-VirtualHIDDevice-Daemon</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>ProcessType</key>
    <string>Interactive</string>
</dict>
</plist>
KEOF
        if ! sudo launchctl print system/org.pqrs.Karabiner-VirtualHIDDevice-Daemon &>/dev/null; then
            sudo launchctl bootstrap system "$KARABINER_PLIST"
        fi
        success "Karabiner VHIDDevice Daemon loaded"
    else
        info "Karabiner VHIDDevice Daemon plist already exists"
    fi

    # 2) Kanata daemon
    KANATA_PLIST="/Library/LaunchDaemons/com.jtroo.kanata.plist"
    KANATA_BIN="$(command -v kanata 2>/dev/null)"
    if [[ -z "$KANATA_BIN" ]]; then
        if [[ "$(uname -m)" == "arm64" ]]; then
            KANATA_BIN="/opt/homebrew/bin/kanata"
        else
            KANATA_BIN="/usr/local/bin/kanata"
        fi
    fi

    sudo tee "$KANATA_PLIST" > /dev/null << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.jtroo.kanata</string>
    <key>ProgramArguments</key>
    <array>
        <string>${KANATA_BIN}</string>
        <string>--cfg</string>
        <string>${HOME}/.config/kanata/kanata.kbd</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>${KANATA_LOG_DIR}/kanata.log</string>
    <key>StandardErrorPath</key>
    <string>${KANATA_LOG_DIR}/kanata.err</string>
</dict>
</plist>
EOF
    if ! sudo launchctl print system/com.jtroo.kanata &>/dev/null; then
        sudo launchctl bootstrap system "$KANATA_PLIST"
    fi
    success "Kanata LaunchDaemon loaded"
    warning "macOS: Grant Input Monitoring permission to kanata in System Settings > Privacy & Security"
fi

success "Dotfiles installation complete!"
echo ""
info "Post-install notes:"
echo "- Open tmux and press 'prefix + I' (Ctrl+b, then Shift+i) to install tmux plugins."
echo "- Open nvim to let lazy.nvim install Neovim plugins."
echo "- Log out and log back in to see all changes take effect."
