#!/bin/bash

# Workspace Tools Installation Script
# This script builds and installs all workspace tools (refac, ldiff, scrap, unscrap, st8)
# Multiple runs will update to the latest version

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default installation directory
DEFAULT_INSTALL_DIR="$HOME/.local/bin"

# Parse command line arguments
INSTALL_DIR="$DEFAULT_INSTALL_DIR"
FORCE_INSTALL=false
VERBOSE=false

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Install Workspace Tools (refac, ldiff, scrap, unscrap, st8)"
    echo ""
    echo "OPTIONS:"
    echo "  -d, --dir DIR        Installation directory (default: $DEFAULT_INSTALL_DIR)"
    echo "  -f, --force          Force reinstallation even if already installed"
    echo "  -v, --verbose        Verbose output"
    echo "  -h, --help           Show this help message"
    echo ""
    echo "EXAMPLES:"
    echo "  $0                           # Install to default location"
    echo "  $0 -d /usr/local/bin         # Install to system directory"
    echo "  $0 --force                   # Force reinstall"
    echo "  $0 -d ~/.local/bin --verbose # Install with verbose output"
}

log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--dir)
            INSTALL_DIR="$2"
            shift 2
            ;;
        -f|--force)
            FORCE_INSTALL=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Verbose output function
verbose_log() {
    if [ "$VERBOSE" = true ]; then
        log "$1"
    fi
}

# Check if we're in the right directory
check_project_directory() {
    if [ ! -f "Cargo.toml" ]; then
        error "Cargo.toml not found. Please run this script from the workspace project root directory."
        exit 1
    fi
    
    if ! grep -q "name = \"refac\"" Cargo.toml; then
        error "This doesn't appear to be the workspace project directory."
        exit 1
    fi
    
    verbose_log "Project directory verified"
}

# Check if cargo is installed
check_cargo() {
    if ! command -v cargo &> /dev/null; then
        error "Cargo is not installed. Please install Rust and Cargo first."
        error "Visit: https://rustup.rs/"
        exit 1
    fi
    
    verbose_log "Cargo found: $(cargo --version)"
}

# Check if installation directory exists and is writable
check_install_directory() {
    if [ ! -d "$INSTALL_DIR" ]; then
        log "Creating installation directory: $INSTALL_DIR"
        mkdir -p "$INSTALL_DIR" || {
            error "Failed to create installation directory: $INSTALL_DIR"
            error "You may need to run with sudo or choose a different directory"
            exit 1
        }
    fi
    
    if [ ! -w "$INSTALL_DIR" ]; then
        error "Installation directory is not writable: $INSTALL_DIR"
        error "You may need to run with sudo or choose a different directory"
        exit 1
    fi
    
    verbose_log "Installation directory verified: $INSTALL_DIR"
}

# Get current installed versions
get_installed_versions() {
    REFAC_VERSION=""
    LDIFF_VERSION=""
    SCRAP_VERSION=""
    UNSCRAP_VERSION=""
    ST8_VERSION=""
    
    if command -v refac &> /dev/null; then
        REFAC_VERSION=$(refac --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "unknown")
    fi
    
    if command -v ldiff &> /dev/null; then
        LDIFF_VERSION=$(ldiff --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "unknown")
    fi
    
    if command -v scrap &> /dev/null; then
        SCRAP_VERSION=$(scrap --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "unknown")
    fi
    
    if command -v unscrap &> /dev/null; then
        UNSCRAP_VERSION=$(unscrap --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "unknown")
    fi
    
    if command -v st8 &> /dev/null; then
        ST8_VERSION=$(st8 --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "unknown")
    fi
}

# Get version from Cargo.toml
get_project_version() {
    PROJECT_VERSION=$(grep '^version = ' Cargo.toml | sed 's/version = "\(.*\)"/\1/')
    verbose_log "Project version: $PROJECT_VERSION"
}

# Check if installation is needed
check_installation_needed() {
    get_installed_versions
    get_project_version
    
    local needs_install=false
    
    if [ "$FORCE_INSTALL" = true ]; then
        log "Force installation requested"
        needs_install=true
    elif [ -z "$REFAC_VERSION" ] || [ -z "$LDIFF_VERSION" ] || [ -z "$SCRAP_VERSION" ] || [ -z "$UNSCRAP_VERSION" ] || [ -z "$ST8_VERSION" ]; then
        log "Some tools are not installed"
        needs_install=true
    elif [ "$REFAC_VERSION" != "$PROJECT_VERSION" ] || [ "$LDIFF_VERSION" != "$PROJECT_VERSION" ] || [ "$SCRAP_VERSION" != "$PROJECT_VERSION" ] || [ "$UNSCRAP_VERSION" != "$PROJECT_VERSION" ] || [ "$ST8_VERSION" != "$PROJECT_VERSION" ]; then
        log "Installed versions differ from project version"
        log "  refac: $REFAC_VERSION -> $PROJECT_VERSION"
        log "  ldiff: $LDIFF_VERSION -> $PROJECT_VERSION"
        log "  scrap: $SCRAP_VERSION -> $PROJECT_VERSION"
        log "  unscrap: $UNSCRAP_VERSION -> $PROJECT_VERSION"
        log "  st8: $ST8_VERSION -> $PROJECT_VERSION"
        needs_install=true
    else
        success "All tools are already up to date (version $PROJECT_VERSION)"
        return 1
    fi
    
    return 0
}

# Build the project
build_project() {
    log "Building workspace tools..."
    
    if [ "$VERBOSE" = true ]; then
        cargo build --release
    else
        cargo build --release --quiet
    fi
    
    # Verify all binaries were built
    local binaries=("refac" "ldiff" "scrap" "unscrap" "st8")
    for binary in "${binaries[@]}"; do
        if [ ! -f "target/release/$binary" ]; then
            error "Failed to build $binary"
            exit 1
        fi
    done
    
    success "Build completed successfully"
}

# Install the binaries
install_binaries() {
    log "Installing binaries to $INSTALL_DIR"
    
    local binaries=("refac" "ldiff" "scrap" "unscrap" "st8")
    for binary in "${binaries[@]}"; do
        verbose_log "Installing $binary..."
        cp "target/release/$binary" "$INSTALL_DIR/"
        chmod +x "$INSTALL_DIR/$binary"
    done
    
    success "Installation completed successfully"
}

# Verify installation
verify_installation() {
    log "Verifying installation..."
    
    local binaries=("refac" "ldiff" "scrap" "unscrap" "st8")
    local all_good=true
    
    for binary in "${binaries[@]}"; do
        if [ -x "$INSTALL_DIR/$binary" ]; then
            local version=$("$INSTALL_DIR/$binary" --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "unknown")
            success "$binary installed successfully (version $version)"
        else
            error "$binary installation failed"
            all_good=false
        fi
    done
    
    if [ "$all_good" = false ]; then
        exit 1
    fi
}

# Check if install directory is in PATH
check_path() {
    if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
        warn "Installation directory $INSTALL_DIR is not in your PATH"
        warn "Add it to your PATH by adding this line to your shell profile:"
        warn "  export PATH=\"$INSTALL_DIR:\$PATH\""
        warn ""
        warn "For bash, add to ~/.bashrc or ~/.bash_profile"
        warn "For zsh, add to ~/.zshrc"
        warn "For fish, run: fish_add_path $INSTALL_DIR"
    else
        success "Installation directory is in your PATH"
    fi
}


# Main installation function
main() {
    log "Starting Workspace Tools installation..."
    log "Installation directory: $INSTALL_DIR"
    
    check_project_directory
    check_cargo
    check_install_directory
    
    if check_installation_needed; then
        build_project
        install_binaries
        verify_installation
        check_path
        
        echo ""
        success "🎉 Workspace Tools installation completed!"
        success "Tools installed: refac, ldiff, scrap, unscrap, st8"
        success "Version: $PROJECT_VERSION"
        success "Location: $INSTALL_DIR"
        
        echo ""
        log "Quick start:"
        log "  refac . \"oldname\" \"newname\" --assume-yes  # Replace strings (auto-confirm)"
        log "  cat /var/log/system.log | ldiff            # Analyze log patterns"
        log "  scrap temp_file.txt                        # Move file to .scrap folder"
        log "  scrap                                       # List .scrap contents"
        log "  unscrap                                     # Restore last scrapped item"
        log "  st8 install                             # Install git hook for version bumping"
        
        echo ""
        log "For more information:"
        log "  refac --help"
        log "  ldiff --help"
        log "  scrap --help"
        log "  unscrap --help"
        log "  st8 --help"
    fi
}

# Run the main function
main "$@"