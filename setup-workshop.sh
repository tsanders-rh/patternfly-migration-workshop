#!/bin/bash

# PatternFly Migration Workshop - Setup Script
# This script verifies and installs all prerequisites for the workshop

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Tracking
ERRORS=()
WARNINGS=()
SUCCESS=()

print_header() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
    SUCCESS+=("$1")
}

print_error() {
    echo -e "${RED}✗${NC} $1"
    ERRORS+=("$1")
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
    WARNINGS+=("$1")
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Version comparison helper
version_ge() {
    printf '%s\n%s' "$2" "$1" | sort -V -C
}

print_header "PatternFly Migration Workshop Setup"

echo "This script will verify and help you set up everything needed for the workshop."
echo "Estimated time: 5-10 minutes"
echo ""

# Detect OS
print_header "System Information"
OS="$(uname -s)"
case "${OS}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    CYGWIN*)    MACHINE=Windows;;
    MINGW*)     MACHINE=Windows;;
    *)          MACHINE="UNKNOWN:${OS}"
esac

echo "Operating System: ${MACHINE}"
echo "Architecture: $(uname -m)"

# Check Node.js
print_header "Checking Node.js"
if command_exists node; then
    NODE_VERSION=$(node --version | sed 's/v//')
    echo "Node.js version: $NODE_VERSION"

    if version_ge "$NODE_VERSION" "18.0.0"; then
        print_success "Node.js 18+ is installed"
    else
        print_error "Node.js version must be 18 or higher (found: $NODE_VERSION)"
        echo "  Install from: https://nodejs.org/"
    fi
else
    print_error "Node.js is not installed"
    echo "  Install from: https://nodejs.org/"
fi

# Check npm
if command_exists npm; then
    NPM_VERSION=$(npm --version)
    print_success "npm is installed (version: $NPM_VERSION)"
else
    print_error "npm is not installed (usually comes with Node.js)"
fi

# Check Git
print_header "Checking Git"
if command_exists git; then
    GIT_VERSION=$(git --version | awk '{print $3}')
    print_success "Git is installed (version: $GIT_VERSION)"
else
    print_error "Git is not installed"
    if [ "$MACHINE" == "Mac" ]; then
        echo "  Install with: brew install git"
    elif [ "$MACHINE" == "Linux" ]; then
        echo "  Install with: sudo apt-get install git (Ubuntu/Debian)"
        echo "            or: sudo yum install git (RHEL/CentOS)"
    fi
fi

# Check Podman or Docker
print_header "Checking Container Runtime (Podman/Docker)"
CONTAINER_RUNTIME=""

if command_exists podman; then
    PODMAN_VERSION=$(podman --version | awk '{print $3}')
    print_success "Podman is installed (version: $PODMAN_VERSION)"
    CONTAINER_RUNTIME="podman"
elif command_exists docker; then
    DOCKER_VERSION=$(docker --version | awk '{print $3}' | sed 's/,//')
    print_success "Docker is installed (version: $DOCKER_VERSION)"
    CONTAINER_RUNTIME="docker"
else
    print_error "Neither Podman nor Docker is installed"
    echo "  For Podman: https://podman.io/getting-started/installation"
    echo "  For Docker: https://docs.docker.com/get-docker/"
fi

# Test container runtime
if [ -n "$CONTAINER_RUNTIME" ]; then
    echo "Testing $CONTAINER_RUNTIME..."
    if $CONTAINER_RUNTIME ps >/dev/null 2>&1; then
        print_success "$CONTAINER_RUNTIME is running and accessible"
    else
        print_warning "$CONTAINER_RUNTIME is installed but not running or not accessible"
        echo "  Try starting $CONTAINER_RUNTIME or check permissions"
        if [ "$CONTAINER_RUNTIME" == "docker" ]; then
            echo "  You may need to add your user to the docker group or start Docker Desktop"
        fi
    fi
fi

# Check/Install Kantra
print_header "Checking Kantra CLI"

KANTRA_VERSION="v0.6.2"
INSTALL_DIR="$HOME/.local/bin"

if command_exists kantra; then
    CURRENT_KANTRA_VERSION=$(kantra version 2>/dev/null | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' || echo "unknown")
    print_success "Kantra is already installed (version: $CURRENT_KANTRA_VERSION)"
else
    echo "Kantra not found. Installing kantra CLI..."

    # Detect architecture
    ARCH="$(uname -m)"
    case "${ARCH}" in
        x86_64)  KANTRA_ARCH="amd64";;
        aarch64) KANTRA_ARCH="arm64";;
        arm64)   KANTRA_ARCH="arm64";;
        *)
            print_error "Unsupported architecture: ${ARCH}"
            KANTRA_ARCH=""
            ;;
    esac

    if [ -n "$KANTRA_ARCH" ]; then
        # Determine OS for download
        case "${MACHINE}" in
            Mac)   KANTRA_OS="darwin";;
            Linux) KANTRA_OS="linux";;
            *)
                print_error "Unsupported OS for kantra installation: ${MACHINE}"
                KANTRA_OS=""
                ;;
        esac

        if [ -n "$KANTRA_OS" ]; then
            KANTRA_BINARY="kantra-${KANTRA_OS}-${KANTRA_ARCH}"
            DOWNLOAD_URL="https://github.com/konveyor/kantra/releases/download/${KANTRA_VERSION}/${KANTRA_BINARY}"

            echo "Downloading kantra from: $DOWNLOAD_URL"

            # Create install directory if it doesn't exist
            mkdir -p "$INSTALL_DIR"

            # Download kantra
            if curl -L -o "$INSTALL_DIR/kantra" "$DOWNLOAD_URL" 2>/dev/null; then
                chmod +x "$INSTALL_DIR/kantra"

                # Check if install dir is in PATH
                if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
                    print_warning "Kantra installed to $INSTALL_DIR but not in PATH"
                    echo "  Add to your PATH by adding this to ~/.bashrc or ~/.zshrc:"
                    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
                    echo ""
                    echo "  Then run: source ~/.bashrc (or source ~/.zshrc)"

                    # Temporarily add to PATH for this script
                    export PATH="$INSTALL_DIR:$PATH"
                fi

                # Verify installation
                if command_exists kantra; then
                    INSTALLED_VERSION=$(kantra version 2>/dev/null | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' || echo "$KANTRA_VERSION")
                    print_success "Kantra installed successfully (version: $INSTALLED_VERSION)"
                else
                    print_error "Kantra downloaded but not accessible in PATH"
                fi
            else
                print_error "Failed to download kantra"
                echo "  You can manually download from: https://github.com/konveyor/kantra/releases"
            fi
        fi
    fi
fi

# Test kantra if available
if command_exists kantra; then
    echo "Testing kantra..."
    if kantra version >/dev/null 2>&1; then
        print_success "Kantra is working correctly"
    else
        print_warning "Kantra is installed but 'kantra version' failed"
    fi
fi

# Check VS Code
print_header "Checking VS Code"
VSCODE_FOUND=false

if command_exists code; then
    VSCODE_VERSION=$(code --version | head -n 1)
    print_success "VS Code is installed (version: $VSCODE_VERSION)"
    VSCODE_FOUND=true
elif [ "$MACHINE" == "Mac" ] && [ -d "/Applications/Visual Studio Code.app" ]; then
    print_warning "VS Code is installed but 'code' command not in PATH"
    echo "  Run VS Code, open Command Palette (Cmd+Shift+P), and run:"
    echo "  'Shell Command: Install code command in PATH'"
    VSCODE_FOUND=true
else
    print_warning "VS Code not detected"
    echo "  Install from: https://code.visualstudio.com/"
fi

# Check for Konveyor extension (if VS Code found)
if [ "$VSCODE_FOUND" = true ] && command_exists code; then
    echo ""
    echo "Checking for Konveyor extension..."
    if code --list-extensions | grep -q "konveyor"; then
        print_success "Konveyor extension is installed"
    else
        print_warning "Konveyor extension not found"
        echo "  Install from VS Code marketplace: search for 'Konveyor'"
        echo "  Or install from command line:"
        echo "  code --install-extension konveyor.konveyor-analyzer"
    fi
fi

# Workshop repository setup
print_header "Workshop Repository Setup"

REPO_URL="https://github.com/tsanders-rh/patternfly-migration-workshop.git"
WORKSHOP_DIR="patternfly-migration-workshop"

if [ -d "$WORKSHOP_DIR" ]; then
    print_info "Workshop directory already exists"
    cd "$WORKSHOP_DIR"

    # Check if it's the right repo
    if git remote get-url origin 2>/dev/null | grep -q "patternfly-migration-workshop"; then
        print_success "Existing workshop repository found"

        echo "Updating repository..."
        if git pull; then
            print_success "Repository updated"
        else
            print_warning "Could not update repository (may have local changes)"
        fi
    else
        print_warning "Directory exists but is not the workshop repository"
        echo "  Please rename or remove the directory and run this script again"
        exit 1
    fi
else
    echo "Cloning workshop repository..."
    if git clone "$REPO_URL"; then
        print_success "Repository cloned successfully"
        cd "$WORKSHOP_DIR"
    else
        print_error "Failed to clone repository"
        exit 1
    fi
fi

# Install dependencies
print_header "Installing Dependencies"
echo "Running npm install (this may take a few minutes)..."

if npm install; then
    print_success "Dependencies installed successfully"
else
    print_error "Failed to install dependencies"
    exit 1
fi

# Run tests
print_header "Running Tests"
echo "Running test suite to verify setup..."

if npm test -- --passWithNoTests 2>&1 | tee /tmp/workshop-test-output.log; then
    if grep -q "Tests:.*passed" /tmp/workshop-test-output.log; then
        print_success "All tests passed"
    else
        print_warning "Tests completed but results unclear"
    fi
else
    print_warning "Tests encountered issues (this may be expected for workshop violations)"
fi

# Try to build
print_header "Testing Build"
echo "Running build to verify configuration..."

if npm run build >/dev/null 2>&1; then
    print_success "Build successful"
else
    print_warning "Build had issues (may be expected for workshop)"
fi

# Summary
print_header "Setup Summary"

if [ ${#SUCCESS[@]} -gt 0 ]; then
    echo -e "${GREEN}Successful checks:${NC}"
    for item in "${SUCCESS[@]}"; do
        echo "  ✓ $item"
    done
    echo ""
fi

if [ ${#WARNINGS[@]} -gt 0 ]; then
    echo -e "${YELLOW}Warnings:${NC}"
    for item in "${WARNINGS[@]}"; do
        echo "  ⚠ $item"
    done
    echo ""
fi

if [ ${#ERRORS[@]} -gt 0 ]; then
    echo -e "${RED}Errors that need attention:${NC}"
    for item in "${ERRORS[@]}"; do
        echo "  ✗ $item"
    done
    echo ""
fi

# Final instructions
print_header "Next Steps"

if [ ${#ERRORS[@]} -eq 0 ]; then
    echo -e "${GREEN}🎉 Setup is complete!${NC}"
    echo ""
    echo "To start the development server:"
    echo "  cd $WORKSHOP_DIR"
    echo "  npm run dev"
    echo ""
    echo "The app will be available at: http://localhost:3000"
    echo ""
    echo "To run tests:"
    echo "  npm test"
    echo ""
    echo "Before the workshop, please also:"
    echo "  1. Get an API key from your AI provider (OpenAI, Anthropic, or setup Ollama)"
    echo "  2. Ensure VS Code Konveyor extension is installed"
    echo "  3. Review the README.md for workshop overview"
    echo ""
    echo "See you at the workshop!"
else
    echo -e "${RED}⚠ Setup incomplete${NC}"
    echo ""
    echo "Please resolve the errors above before the workshop."
    echo "If you need help, please reach out to the workshop organizers."
    echo ""
    echo "Common solutions:"
    echo "  - Install missing software using links provided above"
    echo "  - Ensure Podman/Docker is running"
    echo "  - Check that you have a stable internet connection"
    echo ""
fi

# Create validation report
REPORT_FILE="setup-validation-report.txt"
{
    echo "PatternFly Migration Workshop - Setup Validation Report"
    echo "Generated: $(date)"
    echo "=========================================="
    echo ""
    echo "System: $MACHINE ($(uname -m))"
    echo ""
    echo "SUCCESS (${#SUCCESS[@]}):"
    for item in "${SUCCESS[@]}"; do
        echo "  ✓ $item"
    done
    echo ""
    echo "WARNINGS (${#WARNINGS[@]}):"
    for item in "${WARNINGS[@]}"; do
        echo "  ⚠ $item"
    done
    echo ""
    echo "ERRORS (${#ERRORS[@]}):"
    for item in "${ERRORS[@]}"; do
        echo "  ✗ $item"
    done
} > "$REPORT_FILE"

echo ""
echo "Validation report saved to: $REPORT_FILE"
echo "Please share this report with workshop organizers if you encounter issues."
