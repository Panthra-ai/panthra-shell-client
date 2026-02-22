# Panthra Shell Client

Professional shell client for the Panthra trading API.

## Installation

```bash
# Clone the repository
git clone https://github.com/panthra/panthra-clients.git
cd panthra-clients/panthra-shell-client

# Make the script executable
chmod +x panthra.sh

# Link to system PATH (optional)
sudo ln -s $(pwd)/panthra.sh /usr/local/bin/panthra
```

## Quick Start

```bash
# Set environment variables
export PANTHRA_API_KEY="your-api-key"
export PANTHRA_API_SECRET="your-api-secret"
export PANTHRA_BASE_URL="https://api.panthra.ai/client-api-service/api/v1"

# List all orders
panthra orders list

# List open orders
panthra orders open

# List positions
panthra positions list

# Create market order
panthra orders create --symbol TSLA --side BUY --quantity 1 --type MARKET

# Create limit order
panthra orders create --symbol AAPL --side BUY --quantity 100 --type LIMIT --price 150.50

# Cancel order
panthra orders cancel --order-id 123456

# Cancel all open orders
panthra orders cancel-all

# Get help
panthra --help
```

## Usage

### Configuration

The client reads configuration from environment variables:

```bash
# Required
export PANTHRA_API_KEY="your-api-key"
export PANTHRA_API_SECRET="your-api-secret"

# Optional (defaults to production URL)
export PANTHRA_BASE_URL="https://api.panthra.ai/client-api-service/api/v1"

# Optional (enable debug output)
export PANTHRA_DEBUG=true
```

### Commands

#### Orders

```bash
# List all orders
panthra orders list

# List open orders only
panthra orders open

# Create market order
panthra orders create --symbol TSLA --side BUY --quantity 10 --type MARKET

# Create limit order
panthra orders create --symbol AAPL --side BUY --quantity 100 --type LIMIT --price 150.50

# Create order with all options
panthra orders create \
  --symbol TSLA \
  --asset-type EQUITY \
  --side BUY \
  --quantity 10 \
  --currency USD \
  --type MARKET

# Get specific order
panthra orders get --order-id 123456789

# Cancel order (only open orders)
panthra orders cancel --order-id 123456789

# Cancel all open orders
panthra orders cancel-all
```

#### Positions

```bash
# List positions (default page 0, size 50)
panthra positions list

# List positions with pagination
panthra positions list --page 1 --size 25

# Get all positions (auto-paginate)
panthra positions list-all
```

#### System

```bash
# Show configuration
panthra config

# Test connection
panthra test

# Show version
panthra --version
```

### Output Formats

#### JSON Output (Default)
```json
{
  "orders": [...],
  "open_orders": [...],
  "positions": {...}
}
```

#### Table Output
```bash
panthra orders list --output table
┌─────────────┬──────────────┬──────────┬──────────┐
│ ID         │ Symbol    │ Side   │ Status │ Quantity │
├─────────────┼──────────────┼──────────┼──────────┤
│ 12345     │ TSLA      │ BUY    │ NEW    │ 100     │
│ 67890     │ AAPL      │ SELL   │ FILLED │ 50      │
└─────────────┴──────────────┴──────────┴──────────┘
```

#### CSV Output
```bash
panthra orders list --output csv
id,symbol,side,status,quantity,price,created_at
12345,TSLA,BUY,NEW,100,,2024-01-01T10:00:00Z
67890,AAPL,SELL,FILLED,50,150.50,2024-01-01T11:00:00Z
```

## Options

### Global Options

- `--help, -h` - Show help message
- `--version, -v` - Show version information
- `--debug` - Enable debug output
- `--output, -o` - Output format: json, table, csv
- `--quiet, -q` - Suppress non-error output
- `--config, -c` - Show configuration

### Order Options

- `--symbol` - Trading symbol (required)
- `--side` - Order side: BUY or SELL (required)
- `--quantity` - Order quantity (required)
- `--currency` - Order currency (default: USD)
- `--type` - Order type: MARKET, LIMIT, STOP, STOP_LIMIT (default: MARKET)
- `--price` - Limit price (required for LIMIT orders)
- `--asset-type` - Asset type: EQUITY, ETF, CRYPTO (default: EQUITY)

### Position Options

- `--page` - Page number (default: 0)
- `--size` - Page size (default: 50)

## Examples

### Trading Workflow

```bash
# Check open positions
panthra positions list

# Create limit order below current price
panthra orders create \
  --symbol TSLA \
  --side BUY \
  --quantity 10 \
  --type LIMIT \
  --price 400.00

# Monitor order status
panthra orders get --order-id 123456789

# Cancel if not filled
panthra orders cancel --order-id 123456789
```

### Automation Script

```bash
#!/bin/bash
# trading-bot.sh

# Check for open positions
POSITIONS=$(panthra positions list --output json | jq '.positions | length')
if [ "$POSITIONS" -gt 0 ]; then
    echo "Found open positions, closing all..."
    panthra positions close-all
fi

# Create daily market order
panthra orders create \
  --symbol SPY \
  --side BUY \
  --quantity 1 \
  --type MARKET
```

### API Testing

```bash
#!/bin/bash
# api-test.sh

# Test connection
panthra test

# Test all endpoints
panthra orders list
panthra positions list
panthra orders create \
  --symbol TEST \
  --side BUY \
  --quantity 1 \
  --type MARKET

# Clean up
panthra orders cancel-all
```

## Error Handling

The client provides clear error messages:

```bash
$ panthra orders create --symbol INVALID --side INVALID --quantity -1
Error: Invalid symbol: INVALID

$ panthra orders cancel --order-id 123456
Error: Cannot cancel order 123456. Order status is FILLED, only open orders (NEW, PARTIALLY_FILLED) can be cancelled
```

## Development

### Dependencies

- `curl` - For HTTP requests
- `jq` - For JSON parsing (optional)
- Standard Unix tools: `grep`, `awk`, `sed`

### Testing

```bash
# Run tests
./test.sh

# Lint shell script
shellcheck panthra.sh
```

## License

MIT License
