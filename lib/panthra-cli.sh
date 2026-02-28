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
            
            local response=$(api_request "POST" "/orders" "$payload")
            local order=$(parse_json "$response")
            format_output "$order" "$PANTHRA_OUTPUT"
            ;;
        "cancel")
            if [ $# -lt 1 ]; then
                echo -e "${RED}Error: --order-id is required${NC}"
                return 1
            fi
            local order_id="$1"
            
            local response=$(api_request "PUT" "/orders/$order_id")
            local order=$(parse_json "$response")
            format_output "$order" "$PANTHRA_OUTPUT"
            ;;
        *)
            echo "Unknown orders command: $subcommand"
            return 1
            ;;
    esac
}

# Quotes commands
quotes_command() {
    # Quote only
    local symbol="$1"
    shift || true
    local currency="USD"
    local output_format="$PANTHRA_OUTPUT"

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --symbol)
                symbol="$2"; shift 2 ;;
            --currency)
                currency="$2"; shift 2 ;;
            --output)
                output_format="$2"; shift 2 ;;
            *)
                # Allow positional currency if symbol already set
                if [ -z "$symbol" ]; then
                    symbol="$1"; shift; continue
                elif [ "$currency" = "USD" ]; then
                    currency="$1"; shift; continue
                else
                    echo "Unknown option: $1"; return 1
                fi
                ;;
        esac
    done

    if [ -z "$symbol" ]; then
        echo -e "${RED}Error: symbol is required${NC}"; return 1
    fi

    local response=$(api_request "GET" "/market/quote?symbol=$symbol&currency=$currency")
    local quote=$(parse_json "$response")
    format_output "$quote" "$output_format"
}

# Search commands
search_command() {
    local query=""
    local output_format="$PANTHRA_OUTPUT"

    # Parse args (allow --query or positional)
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --query)
                query="$2"; shift 2 ;;
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
                if [ -z "$query" ]; then
                    query="$1"; shift; continue
                else
                    echo "Unknown option: $1"; return 1
                fi
                ;;
        esac
    done

    if [ -z "$query" ]; then
        echo -e "${RED}Error: --query is required${NC}"
        return 1
    fi

    local response=$(api_request "GET" "/market/search?query=$query")
    local results=$(parse_json "$response")
    format_output "$results" "$output_format"
}

# Balances commands
balances_command() {
    local currency="$1"
    shift || true
    local output_format="$PANTHRA_OUTPUT"

    if [ -z "$currency" ]; then
        echo -e "${RED}Error: currency code is required (e.g. USD, EUR)${NC}"
        return 1
    fi

    # Parse optional args (currently only --output)
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

    local response=$(api_request "GET" "/balances/$currency")
    local balance=$(parse_json "$response")
    format_output "$balance" "$output_format"
}

# Positions commands
positions_command() {
    if [ $# -lt 1 ]; then
        echo -e "${RED}Error: positions requires a subcommand (list | list-all | close | close-all)${NC}"
        return 1
    fi

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
            
            local response=$(api_request "GET" "/positions?page=$page&size=$size")
            local positions=$(parse_json "$response")
            format_output "$positions" "$output_format"
            ;;
        "list-all")
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
            
            local response=$(api_request "DELETE" "/positions/$position_id")
            echo "Position $position_id closed"
            ;;
        "close-all")
            local response=$(api_request "DELETE" "/positions")
            echo "All positions closed"
            ;;
        *)
            echo "Unknown positions command: $subcommand"
            return 1
            ;;
    esac
}
