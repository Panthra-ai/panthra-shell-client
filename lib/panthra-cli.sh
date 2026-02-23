#!/bin/bash

# Panthra CLI Module
# Handles command parsing and routing

# Orders commands
orders_command() {
    local subcommand="$1"
    shift
    
    debug_log "Orders command: $subcommand, args: $*"
    
    case "$subcommand" in
        "list")
            local output_format="$PANTHRA_OUTPUT"
            
            # Parse arguments
            while [[ $# -gt 0 ]]; do
                case "$1" in
                    --output)
                        if [[ $# -gt 1 ]]; then
                            output_format="$2"
                            shift 2
                        else
                            echo -e "${RED}Error: --output requires a value${NC}"
                            return 1
                        fi
                        ;;
                    *)
                        echo "Unknown option: $1"
                        return 1
                        ;;
                esac
            done
            
            echo "=== All Orders ==="
            local response=$(api_request "GET" "/orders")
            local orders=$(parse_json "$response")
            format_output "$orders" "$output_format"
            ;;
        "open")
            local output_format="$PANTHRA_OUTPUT"
            
            # Parse arguments
            while [[ $# -gt 0 ]]; do
                case "$1" in
                    --output)
                        if [[ $# -gt 1 ]]; then
                            output_format="$2"
                            shift 2
                        else
                            echo -e "${RED}Error: --output requires a value${NC}"
                            return 1
                        fi
                        ;;
                    *)
                        echo "Unknown option: $1"
                        return 1
                        ;;
                esac
            done
            
            echo "=== Open Orders ==="
            local response=$(api_request "GET" "/orders/open")
            local orders=$(parse_json "$response")
            format_output "$orders" "$output_format"
            ;;
        "create")
            debug_log "Create order command with args: $*"
            local symbol=""
            local side=""
            local quantity=""
            local currency="USD"
            local type="MARKET"
            local price=""
            local asset_type="EQUITY"
            
            # Parse arguments
            while [[ $# -gt 0 ]]; do
                debug_log "Processing argument: $1, remaining args: $*"
                case "$1" in
                    --symbol)
                        if [[ $# -gt 1 ]]; then
                            symbol="$2"
                            shift 2
                        else
                            echo -e "${RED}Error: --symbol requires a value${NC}"
                            return 1
                        fi
                        ;;
                    --side)
                        if [[ $# -gt 1 ]]; then
                            side="$2"
                            shift 2
                        else
                            echo -e "${RED}Error: --side requires a value${NC}"
                            return 1
                        fi
                        ;;
                    --quantity)
                        if [[ $# -gt 1 ]]; then
                            quantity="$2"
                            shift 2
                        else
                            echo -e "${RED}Error: --quantity requires a value${NC}"
                            return 1
                        fi
                        ;;
                    --currency)
                        if [[ $# -gt 1 ]]; then
                            currency="$2"
                            shift 2
                        else
                            echo -e "${RED}Error: --currency requires a value${NC}"
                            return 1
                        fi
                        ;;
                    --type)
                        if [[ $# -gt 1 ]]; then
                            type="$2"
                            shift 2
                        else
                            echo -e "${RED}Error: --type requires a value${NC}"
                            return 1
                        fi
                        ;;
                    --price)
                        if [[ $# -gt 1 ]]; then
                            price="$2"
                            shift 2
                        else
                            echo -e "${RED}Error: --price requires a value${NC}"
                            return 1
                        fi
                        ;;
                    --asset-type)
                        if [[ $# -gt 1 ]]; then
                            asset_type="$2"
                            shift 2
                        else
                            echo -e "${RED}Error: --asset-type requires a value${NC}"
                            return 1
                        fi
                        ;;
                    *)
                        echo "Unknown option: $1"
                        return 1
                        ;;
                esac
            done
            
            # Validate required parameters
            if [ -z "$symbol" ] || [ -z "$side" ] || [ -z "$quantity" ]; then
                echo -e "${RED}Error: --symbol, --side, and --quantity are required${NC}"
                return 1
            fi
            
            # Validate limit order requires price
            if [ "$type" = "LIMIT" ] && [ -z "$price" ]; then
                echo -e "${RED}Error: --price is required for LIMIT orders${NC}"
                return 1
            fi
            
            # Create order payload
            local payload
            if [ "$type" = "LIMIT" ]; then
                payload=$(cat <<EOF
{
  "symbol": "$symbol",
  "assetType": "$asset_type",
  "side": "$side",
  "quantity": "$quantity",
  "currency": "$currency",
  "orderType": "$type",
  "price": "$price"
}
EOF
)
            else
                payload=$(cat <<EOF
{
  "symbol": "$symbol",
  "assetType": "$asset_type",
  "side": "$side",
  "quantity": "$quantity",
  "currency": "$currency",
  "orderType": "$type"
}
EOF
)
            fi
            
            echo "=== Creating Order ==="
            local response=$(api_request "POST" "/orders" "$payload")
            local order=$(parse_json "$response")
            format_output "$order" "$PANTHRA_OUTPUT"
            ;;
        "get")
            shift
            local order_id="$1"
            if [ -z "$order_id" ]; then
                echo -e "${RED}Error: --order-id is required${NC}"
                return 1
            fi
            
            echo "=== Order Details ==="
            local response=$(api_request "GET" "/orders/$order_id")
            local order=$(parse_json "$response")
            format_output "$order" "$PANTHRA_OUTPUT"
            ;;
        "cancel")
            shift
            local order_id="$1"
            if [ -z "$order_id" ]; then
                echo -e "${RED}Error: --order-id is required${NC}"
                return 1
            fi
            
            echo "=== Canceling Order ==="
            local response=$(api_request "PUT" "/orders/$order_id")
            local order=$(parse_json "$response")
            format_output "$order" "$PANTHRA_OUTPUT"
            ;;
        "cancel-all")
            echo "=== Canceling All Open Orders ==="
            local response=$(api_request "DELETE" "/orders")
            echo "All open orders cancelled"
            ;;
        *)
            echo "Unknown orders command: $subcommand"
            return 1
            ;;
    esac
}

# Positions commands
positions_command() {
    local subcommand="$1"
    shift
    
    case "$subcommand" in
        "list")
            local page=0
            local size=50
            local output_format="$PANTHRA_OUTPUT"
            
            # Parse arguments
            while [[ $# -gt 0 ]]; do
                case "$1" in
                    --page)
                        if [[ $# -gt 1 ]]; then
                            page="$2"
                            shift 2
                        else
                            echo -e "${RED}Error: --page requires a value${NC}"
                            return 1
                        fi
                        ;;
                    --size)
                        if [[ $# -gt 1 ]]; then
                            size="$2"
                            shift 2
                        else
                            echo -e "${RED}Error: --size requires a value${NC}"
                            return 1
                        fi
                        ;;
                    --output)
                        if [[ $# -gt 1 ]]; then
                            output_format="$2"
                            shift 2
                        else
                            echo -e "${RED}Error: --output requires a value${NC}"
                            return 1
                        fi
                        ;;
                    *)
                        echo "Unknown option: $1"
                        return 1
                        ;;
                esac
            done
            
            echo "=== Positions (Page $page, Size $size) ==="
            local response=$(api_request "GET" "/positions?page=$page&size=$size")
            local positions=$(parse_json "$response")
            format_output "$positions" "$output_format"
            ;;
        "list-all")
            echo "=== All Positions ==="
            local page=0
            local size=50
            local has_next=true
            
            while [ "$has_next" = "true" ]; do
                local response=$(api_request "GET" "/positions?page=$page&size=$size")
                local positions=$(parse_json "$response")
                format_output "$positions" "$PANTHRA_OUTPUT"
                
                has_next=$(echo "$positions" | jq -r '.hasNext // "false"')
                if [ "$has_next" = "false" ]; then
                    break
                fi
                
                page=$((page + 1))
            done
            ;;
        "close")
            shift
            local position_id="$1"
            if [ -z "$position_id" ]; then
                echo -e "${RED}Error: --position-id is required${NC}"
                return 1
            fi
            
            echo "=== Closing Position ==="
            local response=$(api_request "DELETE" "/positions/$position_id")
            echo "Position $position_id closed"
            ;;
        "close-all")
            echo "=== Closing All Positions ==="
            local response=$(api_request "DELETE" "/positions")
            echo "All positions closed"
            ;;
        *)
            echo "Unknown positions command: $subcommand"
            return 1
            ;;
    esac
}
