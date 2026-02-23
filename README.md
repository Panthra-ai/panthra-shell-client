# Panthra Shell Client

Professional shell client for the Panthra trading API.

## Installation

### Option 1: One-liner Installation (Recommended)
```bash
curl -sSL https://raw.githubusercontent.com/Panthra-ai/panthra-shell-client/main/install-remote.sh | bash
```

### Option 2: Git Clone
```bash
git clone https://github.com/Panthra-ai/panthra-shell-client.git
cd panthra-shell-client
./install.sh
```

## Configure Credentials

```bash
# Interactive setup
panthra configure

# Verify configuration
panthra config

# Start trading
panthra orders list
panthra positions list
```

## Usage

### Order Management
```bash
# List all orders
panthra orders list

# List open orders
panthra orders open

# Create market order
panthra orders create --symbol TSLA --side BUY --quantity 1 --type MARKET

# Create limit order
panthra orders create --symbol AAPL --side BUY --quantity 100 --type LIMIT --price 150.50

# Cancel order
panthra orders cancel --order-id 123456789
```

### Position Management
```bash
# List positions
panthra positions list

# List all positions (auto-paginate)
panthra positions list-all
```

## Configuration

Credentials are stored in `~/.panthra/credentials`:

```bash
export PANTHRA_API_KEY="your-api-key"
export PANTHRA_API_SECRET="your-api-secret"
export PANTHRA_BASE_URL="http://localhost:8081/client-api-service/api/v1"
```

## Dependencies

- **curl**: HTTP client (usually pre-installed)
- **jq**: JSON parsing (optional, for pretty output)

## License

MIT License - see LICENSE file for details.

## Related Projects

- [JavaScript Client](https://github.com/Panthra-ai/panthra-js-client)
- [Python Client](https://github.com/Panthra-ai/panthra-python-client)
- [Go Client](https://github.com/Panthra-ai/panthra-go-client)
