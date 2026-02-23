#!/bin/bash

# Panthra API Client Module
# Handles HTTP requests to the Panthra API

# Make API request
api_request() {
    local method="$1"
    local endpoint="$2"
    local data="${3:-}"
    local params="${4:-}"
    
    debug_log "Making $method request to $endpoint"
    debug_log "Data: $data"
    debug_log "Params: $params"
    
    local url="$PANTHRA_BASE_URL$endpoint"
    
    local response
    local http_code
    if [ -n "$data" ]; then
        response=$(curl -s -w "\n%{http_code}" \
            -X "$method" \
            -H "Authorization: $PANTHRA_API_KEY" \
            -H "X-Api-Secret: $PANTHRA_API_SECRET" \
            -H "Content-Type: application/json" \
            -d "$data" \
            "$url" \
            2>/dev/null)
        http_code=$(echo "$response" | tail -n1)
        response=$(echo "$response" | head -n -1)
    else
        response=$(curl -s -w "\n%{http_code}" \
            -X "$method" \
            -H "Authorization: $PANTHRA_API_KEY" \
            -H "X-Api-Secret: $PANTHRA_API_SECRET" \
            "$url$params" \
            2>/dev/null)
        http_code=$(echo "$response" | tail -n1)
        response=$(echo "$response" | head -n -1)
    fi
    
    if [ "$http_code" != "200" ]; then
        echo "API Error: HTTP $http_code"
        echo "Response: $response"
        return 1
    fi
    
    echo "$response"
}

# Parse JSON response
parse_json() {
    local response="$1"
    
    debug_log "Raw response: $response"
    
    if command -v jq --version >/dev/null 2>&1; then
        echo "$response" | jq . 2>/dev/null || echo "$response"
    else
        echo "$response"
    fi
}
