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
                echo "$data" | jq -r '.orders[]? | [.id, .symbol, .side, .status, .quantity] | @tsv'
            elif echo "$data" | jq -e '.positions' >/dev/null 2>&1; then
                echo "$data" | jq -r '.positions[]? | [.symbol, .side, .size, .averagePrice, .currentValue] | @tsv'
            elif echo "$data" | jq -e '.[0].id' >/dev/null 2>&1; then
                # Direct orders array
                echo "$data" | jq -r '.[]? | [.id, .symbol, .side, .status, .quantity] | @tsv'
            else
                echo "$data"
            fi
            ;;
        "csv")
            # Check if it's orders or positions data
            if echo "$data" | jq -e '.orders' >/dev/null 2>&1; then
                echo "$data" | jq -r '.orders[]? | [.id, .symbol, .side, .status, .quantity, .price, .createdAt] | @csv'
            elif echo "$data" | jq -e '.positions' >/dev/null 2>&1; then
                echo "$data" | jq -r '.positions[]? | [.symbol, .side, .size, .averagePrice, .currentValue, .updatedAt] | @csv'
            elif echo "$data" | jq -e '.[0].id' >/dev/null 2>&1; then
                # Direct orders array
                echo "$data" | jq -r '.[]? | [.id, .symbol, .side, .status, .quantity, .createdAt] | @csv'
            else
                echo "$data"
            fi
            ;;
        *)
            echo "$data"
            ;;
    esac
}
