#!/bin/bash

# Panthra CLI Remote Installation Script
# Downloads and installs the Panthra CLI without requiring git

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuration
REPO_URL="https://github.com/Panthra-ai/panthra-shell-client.git"
BRANCH="main"
INSTALL_DIR="/usr/local/bin"

echo -e "${GREEN}Installing Panthra CLI...${NC}"

# Create temporary directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Download the repository
echo "Downloading Panthra CLI..."
curl -sL https://codeload.github.com/Panthra-ai/panthra-shell-client/tar.gz/main | tar xz --strip-components=1

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    INSTALL_DIR="/usr/local/bin"
else
    # Try directories that are already in PATH and writable
    for dir in "/opt/homebrew/bin" "/usr/local/bin"; do
        if [ -w "$dir" ]; then
            INSTALL_DIR="$dir"
            echo -e "${GREEN}Installing to $dir (already in PATH)${NC}"
            break
        fi
    done
    
    # If no writable directory found, fallback to ~/.local/bin
    if [ -z "$INSTALL_DIR" ]; then
        echo -e "${YELLOW}No writable directory in PATH. Installing to ~/.local/bin${NC}"
        INSTALL_DIR="$HOME/.local/bin"
        mkdir -p "$INSTALL_DIR"
        
        # Add to PATH if not already there
        if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
            echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$HOME/.bashrc"
            echo -e "${YELLOW}Added $INSTALL_DIR to PATH in ~/.bashrc${NC}"
            echo -e "${YELLOW}Run 'source ~/.bashrc' or restart your terminal to use the command${NC}"
        fi
    fi
fi

# Create symlink
if [ -L "$INSTALL_DIR/panthra" ]; then
    echo -e "${YELLOW}Removing existing symlink...${NC}"
    rm "$INSTALL_DIR/panthra"
fi

# Copy files instead of creating symlink to temp directory
mkdir -p "$HOME/.panthra-cli"
cp -r "$TEMP_DIR"/* "$HOME/.panthra-cli/"

# Create a wrapper script that updates PATH
cat > "$INSTALL_DIR/panthra" << 'EOF'
#!/bin/bash
# Update PATH for this session
export PATH="$HOME/.panthra-cli/bin:$PATH"
# Execute the real panthra
exec "$HOME/.panthra-cli/bin/panthra" "$@"
EOF

chmod +x "$INSTALL_DIR/panthra"

# Cleanup
cd /
rm -rf "$TEMP_DIR"

echo -e "${GREEN}✓ Panthra CLI installed successfully!${NC}"
echo -e "${GREEN}✓ Command available as: panthra${NC}"
echo ""
echo "Testing installation..."
panthra --version
echo ""
echo "Next steps:"
echo "  panthra configure"
echo "  panthra orders list"
