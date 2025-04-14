#!/usr/bin/env bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print a header
header() {
    echo -e "\n${BLUE}==>${NC} ${BLUE}$1${NC}"
}

# Print an info message
info() {
    echo -e "${BLUE}INFO:${NC} $1"
}

# Print a success message
success() {
    echo -e "${GREEN}SUCCESS:${NC} $1"
}

# Print a warning message
warning() {
    echo -e "${YELLOW}WARNING:${NC} $1"
}

# Print an error message
error() {
    echo -e "${RED}ERROR:${NC} $1"
}

# Create a symlink with backup
link_file() {
    local src="$1"
    local dest="$2"
    local backup_dir="${HOME}/.dotfiles_backup/$(date +%Y%m%d-%H%M%S)"

    # Check if the destination already exists and is not a symlink to the source
    if [[ -e "$dest" && ! -L "$dest" ]] || [[ -L "$dest" && "$(readlink "$dest")" != "$src" ]]; then
        if [[ "$FORCE" == "true" ]]; then
            # Create backup directory if it doesn't exist
            mkdir -p "$backup_dir"

            # Backup the existing file
            mv "$dest" "${backup_dir}/$(basename "$dest")"
            info "Backed up existing file: $dest to ${backup_dir}/$(basename "$dest")"
        else
            warning "File already exists: $dest. Use --force to overwrite."
            return 1
        fi
    fi

    # Create the symlink
    ln -sf "$src" "$dest"
    success "Linked $src to $dest"
}

# Check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Log to a file
log_to_file() {
    local log_file="${DOTFILES_DIR}/install.log"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[${timestamp}] $1" >> "$log_file"
}

# Run a command with logging
run_command() {
    local cmd="$1"
    local error_msg="${2:-Command failed}"

    info "Running: $cmd"
    log_to_file "Running: $cmd"

    if ! eval "$cmd"; then
        error "$error_msg"
        log_to_file "ERROR: $error_msg"
        return 1
    fi

    return 0
}