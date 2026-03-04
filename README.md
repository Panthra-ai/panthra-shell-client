# Panthra Shell Client

Professional shell client for the Panthra trading API.

[Full Documentation](https://dev.panthra.ai/documentation/clients-panthra-shell-client)

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

## Configuration

### Step 1: Get API Credentials

1. Sign up at [Panthra Platform](https://panthra.ai)
2. Navigate to API Settings in your dashboard
3. Generate your API Key and Secret
4. Save these credentials securely

### Step 2: Configure the Client

**Option 1: Interactive Configuration (Recommended)**

```bash
# Run interactive setup
panthra configure

# You will be prompted for:
# - API Key
# - API Secret
# (Base URL is automatically set to https://api.panthra.ai/v1)
```

Credentials are stored in `~/.panthra/credentials` with secure permissions (600).

**Option 2: Environment Variables**

```bash
export PANTHRA_API_KEY="your-api-key"
export PANTHRA_API_SECRET="your-api-secret"
export PANTHRA_BASE_URL="https://api.panthra.ai/v1"  # Optional, this is the default
```

### Step 3: Verify Configuration

```bash
# View current configuration (credentials are masked)
panthra config

# Test connection with a simple command
panthra balances USD --output table

# Or list your orders
panthra orders list --output table
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
# or
panthra balances get USD --output table
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
export PANTHRA_BASE_URL="https://api.panthra.ai/v1"
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

[Full Documentation & Tutorials](https://dev.panthra.ai/documentation/clients-panthra-shell-client) |  
[Panthra Trading Platform](https://dev.panthra.ai) |  
[Support & Community](https://dev.panthra.ai/support)
