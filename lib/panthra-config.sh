#!/bin/bash

# Panthra Configuration Module
# Handles environment variables and configuration

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Load configuration
load_config() {
    # Get the directory where the main script is located
    local SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd)"
    
    # Load environment variables from project .env (for development)
    if [ -f "$SCRIPT_DIR/../.env" ]; then
        source "$SCRIPT_DIR/../.env"
    fi
    
    # Load user credentials from ~/.panthra/credentials (like AWS CLI)
    if [ -f "$HOME/.panthra/credentials" ]; then
        source "$HOME/.panthra/credentials"
    fi
    
    # Set defaults
    PANTHRA_API_KEY="${PANTHRA_API_KEY:-}"
    PANTHRA_API_SECRET="${PANTHRA_API_SECRET:-}"
    PANTHRA_BASE_URL="${PANTHRA_BASE_URL:-https://dev-api.panthra.ai/client-api-service/api/v1}"
    PANTHRA_DEBUG="${PANTHRA_DEBUG:-false}"
    PANTHRA_OUTPUT="${PANTHRA_OUTPUT:-json}"
}

# Configure credentials
configure_credentials() {
    echo -e "${GREEN}Panthra CLI Configuration${NC}"
    echo "Please enter your API credentials:"
    echo ""
    
    # Get API key
    read -p "API Key: " api_key
    while [ -z "$api_key" ]; do
        echo -e "${RED}API Key is required${NC}"
        read -p "API Key: " api_key
    done
    
    # Get API secret
    read -s -p "API Secret: " api_secret
    echo ""
    while [ -z "$api_secret" ]; do
        echo -e "${RED}API Secret is required${NC}"
        read -s -p "API Secret: " api_secret
        echo ""
    done
    
    # Set base URL to local endpoint by default
    base_url="https://dev-api.panthra.ai/client-api-service/api/v1"
    
    # Create ~/.panthra directory
    mkdir -p "$HOME/.panthra"
    
    # Write credentials file
    cat > "$HOME/.panthra/credentials" << EOF
# Panthra API Credentials
# Generated on $(date)
export PANTHRA_API_KEY="$api_key"
export PANTHRA_API_SECRET="$api_secret"
export PANTHRA_BASE_URL="$base_url"
export PANTHRA_DEBUG=false
export PANTHRA_OUTPUT=json
EOF
    
    # Set proper permissions
    chmod 600 "$HOME/.panthra/credentials"
    
    echo ""
    echo -e "${GREEN}✓ Credentials saved to ~/.panthra/credentials${NC}"
    echo -e "${GREEN}✓ Configuration complete!${NC}"
    echo ""
    echo "Test your configuration:"
    echo "  panthra config"
    echo "  panthra orders list"
}
show_config() {
    echo "API Key: ${PANTHRA_API_KEY:0:8}..."
    echo "API Secret: ${PANTHRA_API_SECRET:0:8}..."
    echo "Base URL: $PANTHRA_BASE_URL"
    echo "Debug Mode: $PANTHRA_DEBUG"
    echo "Output Format: $PANTHRA_OUTPUT"
}

# Show version
show_version() {
    echo "v1.0.0"
}

# Show help
show_help() {
    cat << 'EOF'
Panthra Shell Client - Professional shell client for the Panthra trading API

USAGE:
    panthra <command> [options] [arguments]

COMMANDS:
    orders        - Order management commands
    positions     - Position management commands
    config        - Show current configuration
    configure     - Set up API credentials
    version       - Show version information
    help          - Show this help message

ORDER COMMANDS:
    list          List all orders
    open          List open orders
    create        Create new order
    get <id>     Get specific order
    cancel <id>   Cancel order (open orders only)
    cancel-all    Cancel all open orders

POSITION COMMANDS:
    list          List positions
    list-all      List all positions (auto-paginate)
    close <id>    Close position
    close-all      Close all positions

GLOBAL OPTIONS:
    --help, -h     Show help message
    --version, -v  Show version information
    --debug, -d    Enable debug output
    --output, -o    Output format: json, table, csv
    --quiet, -q    Suppress non-error output

ORDER OPTIONS:
    --symbol      Trading symbol (required)
    --side        Order side: BUY or SELL (required)
    --quantity    Order quantity (required)
    --currency     Order currency (default: USD)
    --type        Order type: MARKET, LIMIT, STOP, STOP_LIMIT (default: MARKET)
    --price       Limit price (required for LIMIT orders)
    --asset-type   Asset type: EQUITY, ETF, CRYPTO (default: EQUITY)

POSITION OPTIONS:
    --page        Page number (default: 0)
    --size        Page size (default: 50)

EXAMPLES:
    panthra orders list
    panthra orders create --symbol TSLA --side BUY --quantity 10 --type MARKET
    panthra orders create --symbol AAPL --side BUY --quantity 100 --type LIMIT --price 150.50
    panthra positions list --output table
    panthra orders cancel-all
EOF
}

# Debug logging
debug_log() {
    if [ "$PANTHRA_DEBUG" = "true" ]; then
        echo -e "${YELLOW}[DEBUG] $1${NC}" >&2
    fi
}

# Initialize configuration
load_config
