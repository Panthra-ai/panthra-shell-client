#!/usr/bin/env bash
set -uo pipefail

CLI="panthra"

run() {
  printf "> %s\n" "$*"
  "$@"
}

# Core flows
run "$CLI" search META --output table
run "$CLI" quotes META USD --output table
run "$CLI" balances USD --output table
run "$CLI" positions list --output table || true
run "$CLI" orders list --output table || true

# Market order
market_resp=$(PANTHRA_OUTPUT=json $CLI orders create --symbol META --side BUY --quantity 1 --currency USD --type MARKET --asset-type EQUITY)
if echo "$market_resp" | grep -qi "invalid-onboarding"; then
  echo "Market order failed (invalid-onboarding). Response: $market_resp" >&2
  exit 1
fi
market_id=$(echo "$market_resp" | grep -oE '[0-9a-fA-F-]{36}' | head -1)
if [ -z "$market_id" ]; then
  echo "Failed to parse market order id. Response: $market_resp" >&2
  exit 1
fi
echo "market order id: $market_id"
run "$CLI" orders list --output table

# Limit order create + cancel
limit_resp=$(PANTHRA_OUTPUT=json $CLI orders create --symbol META --side BUY --quantity 1 --currency USD --type LIMIT --price 600 --asset-type EQUITY)
if echo "$limit_resp" | grep -qi "invalid-onboarding"; then
  echo "Limit order failed (invalid-onboarding). Response: $limit_resp" >&2
  exit 1
fi
limit_id=$(echo "$limit_resp" | grep -oE '[0-9a-fA-F-]{36}' | head -1)
if [ -z "$limit_id" ]; then
  echo "Failed to parse limit order id. Response: $limit_resp" >&2
  exit 1
fi
echo "limit order id: $limit_id"
run "$CLI" orders cancel "$limit_id"
run "$CLI" orders list --output table || true
run "$CLI" positions list --output table || true

echo "E2E smoke complete"
