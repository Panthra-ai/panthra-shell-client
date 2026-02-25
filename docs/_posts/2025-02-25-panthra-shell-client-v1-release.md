---
layout: post
title: "Panthra Shell Client v1.0 Released - Cross-Platform Trading API Client"
description: "Announcing the release of Panthra Shell Client v1.0 with universal cross-platform support, one-liner installation, and professional trading API integration."
author: "Panthra Team"
date: 2025-02-25 10:00:00 +0000
categories: [releases, api-clients]
tags: [shell-client, trading-api, cross-platform, automation, cryptocurrency]
image: "/assets/images/panthra-shell-client-release.jpg"
seo:
  type: BlogPosting
---

# 🚀 Panthra Shell Client v1.0 Released

We're excited to announce the official release of **Panthra Shell Client v1.0** - a professional, cross-platform shell client for the Panthra trading API!

## ✨ Key Features

### 🌍 Universal Cross-Platform Support
- **Linux**, **macOS**, and **Windows (WSL)**
- **Universal shell support**: Bash, Zsh, Fish, and all other shells
- **Single configuration**: Uses `~/.profile` for maximum compatibility

### ⚡ One-Liner Installation
```bash
curl -sSL https://raw.githubusercontent.com/Panthra-ai/panthra-shell-client/main/install-remote.sh | bash
```

### 🔧 Professional Trading Tools
- **Real-time order management**: Create, list, cancel orders
- **Position tracking**: Monitor open and closed positions
- **Secure authentication**: API key and secret management
- **JSON output**: Clean, structured data for automation

## 🛠️ Installation & Usage

### Quick Start
```bash
# Install
curl -sSL https://raw.githubusercontent.com/Panthra-ai/panthra-shell-client/main/install-remote.sh | bash

# Activate
source ~/.profile

# Configure
panthra configure

# Start trading
panthra orders list
panthra positions open
```

### Configuration
```bash
# Interactive setup
panthra configure

# Or set environment variables
export PANTHRA_API_KEY="your-api-key"
export PANTHRA_API_SECRET="your-api-secret"
export PANTHRA_BASE_URL="https://dev-api.panthra.ai/client-api-service/api/v1"
```

## 📊 API Capabilities

### Order Management
```bash
# List all orders
panthra orders list

# Create a new order
panthra orders create --symbol BTC/USDT --side buy --amount 0.01 --price 50000

# Cancel an order
panthra orders cancel --order-id 12345

# Cancel all orders
panthra orders cancel-all
```

### Position Tracking
```bash
# List open positions
panthra positions open

# List all positions
panthra positions list

# Get position details
panthra positions get --position-id pos_12345
```

## 🏗️ Architecture

The shell client is built with a **modular architecture** for maintainability and extensibility:

```
panthra-shell-client/
├── bin/panthra              # Main entry point
├── lib/
│   ├── panthra-config.sh    # Configuration management
│   ├── panthra-client.sh    # HTTP API client
│   ├── panthra-cli.sh       # Command-line interface
│   └── panthra-format.sh    # Output formatting
└── install-remote.sh        # One-liner installer
```

## 🔒 Security Features

- **Secure credential storage** in `~/.panthra/credentials`
- **HTTPS-only API communication**
- **No sensitive data in command history**
- **Environment variable support** for CI/CD

## 🌐 SEO & Documentation

This release includes:
- **Full documentation** at [de.panthra.ai/documentation/clients-panthra-shell-client](https://de.panthra.ai/documentation/clients-panthra-shell-client)
- **SEO-optimized README** with proper meta tags
- **Cross-platform compatibility** tested on multiple systems

## 🚀 What's Next?

### v1.1 Roadmap
- **Advanced order types** (limit, stop-loss, take-profit)
- **Portfolio analytics** and reporting
- **WebSocket streaming** for real-time data
- **Shell completion** scripts

### v2.0 Vision
- **Multi-exchange support**
- **Advanced trading strategies**
- **Backtesting framework**
- **Web dashboard integration**

## 🤝 Contributing

We welcome contributions! Check out our [GitHub repository](https://github.com/Panthra-ai/panthra-shell-client) to:
- Report issues and feature requests
- Submit pull requests
- Improve documentation
- Share your trading strategies

## 📚 Resources

- **📖 [Full Documentation](https://de.panthra.ai/documentation/clients-panthra-shell-client)**
- **🌐 [Panthra Trading Platform](https://de.panthra.ai)**
- **📧 [Support & Community](https://de.panthra.ai/support)**
- **💻 [GitHub Repository](https://github.com/Panthra-ai/panthra-shell-client)**

---

**Ready to automate your trading?** [Install Panthra Shell Client v1.0 today!](https://github.com/Panthra-ai/panthra-shell-client)

*Follow us on [Twitter (@panthra_ai)](https://twitter.com/panthra_ai) for updates and trading tips!*
