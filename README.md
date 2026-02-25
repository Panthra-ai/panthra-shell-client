# Panthra Shell Client

Professional shell client for the Panthra trading API.

**📖 [Full Documentation](https://de.panthra.ai/documentation/clients-panthra-shell-client)**

## Installation

### Option 1: One-liner Installation (Recommended)
```bash
curl -sSL https://raw.githubusercontent.com/Panthra-ai/panthra-shell-client/main/install-remote.sh | bash
```
*Installs to ~/.local/bin and updates your shell configuration*

### Option 2: Git Clone
```bash
git clone https://github.com/Panthra-ai/panthra-shell-client.git
cd panthra-shell-client
./install.sh
```

## Post-Installation

After installation, run one of the following commands to make `panthra` available:

```bash
# For immediate use (recommended)
source ~/.profile

# Or restart your terminal
```

The installer automatically updates `~/.profile`, which works across all platforms and shells.

## Installation Details

### File Location
- **Files stored in**: `~/.local/bin/` and `~/.local/bin/lib/`
- **Shell configuration**: Automatically updated in `~/.profile`
- **Cross-platform**: Works on Linux, macOS, Windows (WSL)
- **Universal shell support**: Works with Bash, Zsh, Fish, and all other shells
- **PATH requirement**: Run `source ~/.profile` or restart terminal after installation

### Verification
```bash
# Verify installation (after sourcing or restart)
source ~/.profile
panthra --version

# Check installation location
which panthra
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
export PANTHRA_BASE_URL="https://dev-api.panthra.ai/client-api-service/api/v1"
```

## Dependencies

- **curl**: HTTP client (usually pre-installed)
- **jq**: JSON parsing (optional, for pretty output)

## License

MIT License - see LICENSE file for details.

## Related Projects

- [Panthra JavaScript Client](https://github.com/Panthra-ai/panthra-js-client)
- [Panthra Python Client](https://github.com/Panthra-ai/panthra-python-client)
- [Panthra Go Client](https://github.com/Panthra-ai/panthra-go-client)

---

**📖 [Full Documentation & Tutorials](https://de.panthra.ai/documentation/clients-panthra-shell-client)** |  
**🌐 [Panthra Trading Platform](https://de.panthra.ai)** |  
**📧 [Support & Community](https://de.panthra.ai/support)**
