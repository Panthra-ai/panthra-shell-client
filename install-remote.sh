#!/bin/bash

# Panthra CLI Remote Installation Script
# Downloads and installs the Panthra CLI

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Installing Panthra CLI...${NC}"

# Create temporary directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Download the repository
echo "Downloading Panthra CLI..."
curl -sL https://codeload.github.com/Panthra-ai/panthra-shell-client/tar.gz/main | tar xz --strip-components=1

# Install to ~/.local/bin
INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"
echo -e "${GREEN}Installing to $INSTALL_DIR${NC}"

# Copy files
cp -r bin/* "$INSTALL_DIR/"
cp -r lib "$INSTALL_DIR/"

# Fix the LIB_DIR path in the main script
sed -i '' '2i\
# Set INSTALL_DIR for this script\
INSTALL_DIR="'"$INSTALL_DIR"'"' "$INSTALL_DIR/panthra"
sed -i '' 's|LIB_DIR="$SCRIPT_DIR/../lib"|LIB_DIR="$INSTALL_DIR/lib"|g' "$INSTALL_DIR/panthra"

# Update PATH in shell config files
update_shell_config() {
    local shell_config="$HOME/.profile"
    
    # Add PATH if not already there
    if ! grep -q "export PATH.*$INSTALL_DIR" "$shell_config" 2>/dev/null; then
        echo "" >> "$shell_config"
        echo "# Panthra CLI" >> "$shell_config"
        echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$shell_config"
        echo -e "${YELLOW}Added PATH to $shell_config${NC}"
        echo -e "${YELLOW}Run 'source $shell_config' or restart your terminal to apply the changes${NC}"
    fi
}

# Update shell config files
update_shell_config

# Update PATH for current session
export PATH="$INSTALL_DIR:$PATH"

# Cleanup
cd /
rm -rf "$TEMP_DIR"

echo -e "${GREEN}✓ Panthra CLI installed successfully!${NC}"
echo -e "${GREEN}✓ Command available as: panthra${NC}"
echo ""
echo "Restart your terminal and run:"
echo "  panthra configure"
echo "  panthra orders list"
