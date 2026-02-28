#!/bin/bash

# Panthra Format Module
# Handles output formatting

# Format output
format_output() {
    local data="$1"
    local format="$2"
    
    case "$format" in
        "table")
            # Check if it's orders or positions data
            if echo "$data" | jq -e '.orders' >/dev/null 2>&1; then
                {
                    echo -e "id\tsymbol\tside\tstatus\tquantity"
                    echo "$data" | jq -r '.orders[]? | [.id, .symbol, .side, .status, .quantity] | @tsv'
                } | column -t -s $'\t'
            elif echo "$data" | jq -e '.positions' >/dev/null 2>&1; then
                {
                    echo -e "symbol\tside\tsize\taveragePrice\tcurrentValue"
                    echo "$data" | jq -r '.positions[]? | [.symbol, .side, .size, .averagePrice, .currentValue] | @tsv'
                } | column -t -s $'\t'
            elif echo "$data" | jq -e '.price' >/dev/null 2>&1; then
                {
                    echo -e "symbol\tname\tassetType\tcurrency\tprice\tchange\tchangePercent\thigh\tlow\topen\tpreviousClose\tvolume\ttimestamp"
                    echo "$data" | jq -r '[.symbol, .name, .assetType, .currency, .price, .change, .changePercent, .high, .low, .open, .previousClose, .volume, .timestamp] | @tsv'
                } | column -t -s $'\t'
            elif echo "$data" | jq -e '.currency' >/dev/null 2>&1; then
                {
                    echo -e "currency\taccountValue\tbuyingPower\tcash\tpnl\topenPositions\topenOrders"
                    echo "$data" | jq -r '[.currency, .accountValue, .buyingPower, .cash, .pnl, .openPositions, .openOrders] | @tsv'
                } | column -t
            elif echo "$data" | jq -e '.[0].symbol' >/dev/null 2>&1 && echo "$data" | jq -e '.[0].name' >/dev/null 2>&1; then
                {
                    echo -e "symbol\tname\tcurrency\ttype"
                    echo "$data" | jq -r '.[]? | [.symbol, .name, .currency, .type] | @tsv'
                } | column -t -s $'\t'
            elif echo "$data" | jq -e '.[0].id' >/dev/null 2>&1; then
                # Direct orders array
                {
                    echo -e "id\tsymbol\tside\tstatus\tquantity"
                    echo "$data" | jq -r '.[]? | [.id, .symbol, .side, .status, .quantity] | @tsv'
                } | column -t -s $'\t'
            else
                echo "$data"
            fi
            ;;
        "json"|"")
            echo "$data"
            ;;
        *)
            echo -e "${RED}Error: unsupported output format '$format' (use json or table)${NC}" >&2
            return 1
            ;;
    esac
}
