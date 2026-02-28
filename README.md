# Panthra Shell Client

Professional shell client for the Panthra trading API.

**📖 [Full Documentation](https://dev.panthra.ai/documentation/clients-panthra-shell-client)**

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

If `panthra` is still not found, add the PATH manually for your shell and re-source:

**Bash/Zsh (Linux/macOS/WSL)**
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.profile
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.profile
```

**Fish**
```fish
set -U fish_user_paths $HOME/.local/bin $fish_user_paths
```

**Windows (PowerShell)**
Add `%USERPROFILE%\.local\bin` to your user PATH environment variable, then open a new shell.

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

Output formats: `table` (human) or `json` (default). CSV is not supported.

### Orders
```bash
# List all orders
panthra orders list --output table

# List open orders
panthra orders open --output table

# Create market order
panthra orders create --symbol TSLA --side BUY --quantity 1 --type MARKET

# Create limit order
panthra orders create --symbol AAPL --side BUY --quantity 100 --type LIMIT --price 150.50

# Cancel order
panthra orders cancel <order-id>
```

### Positions
```bash
# List positions
panthra positions list --output table

# List all positions (auto-paginate)
panthra positions list-all --output table
```

### Balances
```bash
panthra balances USD --output table
```

### Quotes & Search
```bash
# Search tradable symbols
panthra search META --output table

# Get a quote
panthra quotes META USD --output table
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

**📖 [Full Documentation & Tutorials](https://dev.panthra.ai/documentation/clients-panthra-shell-client)** |  
**🌐 [Panthra Trading Platform](https://dev.panthra.ai)** |  
**📧 [Support & Community](https://dev.panthra.ai/support)**
