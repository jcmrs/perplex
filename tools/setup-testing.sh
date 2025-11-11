#!/usr/bin/env bash
# Install testing dependencies for Project Perplex
# Supports macOS (Homebrew) and Linux (apt/yum)

set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Project Perplex - Testing Setup${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Detect OS
OS="unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
fi

echo "Detected OS: $OS"
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to print success
success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Function to print failure
failure() {
    echo -e "${RED}✗ $1${NC}"
}

# Function to print info
info() {
    echo -e "${BLUE}→ $1${NC}"
}

# Function to print warning
warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# 1. Install shellcheck
echo -e "${BLUE}Installing shellcheck...${NC}"
if command_exists shellcheck; then
    success "shellcheck already installed ($(shellcheck --version | head -1))"
else
    if [ "$OS" = "macos" ]; then
        if command_exists brew; then
            info "Installing via Homebrew..."
            brew install shellcheck
            success "shellcheck installed"
        else
            warning "Homebrew not found. Please install from: https://www.shellcheck.net/"
        fi
    elif [ "$OS" = "linux" ]; then
        if command_exists apt-get; then
            info "Installing via apt..."
            sudo apt-get update
            sudo apt-get install -y shellcheck
            success "shellcheck installed"
        elif command_exists yum; then
            info "Installing via yum..."
            sudo yum install -y ShellCheck
            success "shellcheck installed"
        else
            warning "Package manager not found. Please install from: https://www.shellcheck.net/"
        fi
    else
        warning "Unsupported OS. Please install from: https://www.shellcheck.net/"
    fi
fi

echo ""

# Function to install bats from source
install_bats_from_source() {
    BATS_VERSION="v1.10.0"
    TEMP_DIR=$(mktemp -d)

    info "Cloning bats-core $BATS_VERSION..."
    git clone --depth 1 --branch "$BATS_VERSION" https://github.com/bats-core/bats-core.git "$TEMP_DIR"

    cd "$TEMP_DIR" || exit 1
    info "Installing to /usr/local..."
    sudo ./install.sh /usr/local

    cd - >/dev/null || exit 1
    rm -rf "$TEMP_DIR"

    success "bats-core installed from source"
}

# 2. Install bats
echo -e "${BLUE}Installing bats-core...${NC}"
if command_exists bats; then
    success "bats already installed ($(bats --version))"
else
    if [ "$OS" = "macos" ]; then
        if command_exists brew; then
            info "Installing via Homebrew..."
            brew install bats-core
            success "bats-core installed"
        else
            warning "Homebrew not found. Installing from source..."
            install_bats_from_source
        fi
    else
        info "Installing from source..."
        install_bats_from_source
    fi
fi

echo ""

# 3. Install yamllint
echo -e "${BLUE}Installing yamllint...${NC}"
if command_exists yamllint; then
    success "yamllint already installed ($(yamllint --version))"
else
    if command_exists pip3; then
        info "Installing via pip3..."
        pip3 install --user yamllint
        success "yamllint installed"

        # Check if pip user bin is in PATH
        if ! command_exists yamllint; then
            warning "yamllint installed but not in PATH"
            warning "Add to PATH: export PATH=\"\$HOME/.local/bin:\$PATH\""
        fi
    elif command_exists pip; then
        info "Installing via pip..."
        pip install --user yamllint
        success "yamllint installed"

        if ! command_exists yamllint; then
            warning "yamllint installed but not in PATH"
            warning "Add to PATH: export PATH=\"\$HOME/.local/bin:\$PATH\""
        fi
    else
        warning "pip not found. Please install Python and pip first"
        warning "Then run: pip install yamllint"
    fi
fi

echo ""

# Summary
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Installation Summary${NC}"
echo -e "${BLUE}========================================${NC}"

if command_exists shellcheck; then
    success "shellcheck: $(shellcheck --version | head -1)"
else
    failure "shellcheck: NOT INSTALLED"
fi

if command_exists bats; then
    success "bats: $(bats --version)"
else
    failure "bats: NOT INSTALLED"
fi

if command_exists yamllint; then
    success "yamllint: $(yamllint --version)"
else
    failure "yamllint: NOT INSTALLED"
fi

echo ""
echo -e "${BLUE}========================================${NC}"

if command_exists shellcheck && command_exists bats && command_exists yamllint; then
    echo -e "${GREEN}✓ All testing dependencies installed!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Run tests: ./tests/run-tests.sh"
    echo "  2. See documentation: tests/README.md"
    exit 0
else
    echo -e "${YELLOW}⚠ Some dependencies missing${NC}"
    echo ""
    echo "Please install missing dependencies manually."
    echo "See: tests/README.md for installation instructions"
    exit 1
fi
