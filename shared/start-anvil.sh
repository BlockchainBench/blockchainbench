#!/usr/bin/env bash
# Start an Anvil fork for the given task configuration.
# Forks Ethereum mainnet at block 21000000.
# Uses $ETH_RPC_URL for the RPC endpoint (defaults to public endpoint).
set -euo pipefail

FORK_BLOCK=21000000
DEFAULT_RPC="https://eth.llamarpc.com"
RPC_URL="${ETH_RPC_URL:-$DEFAULT_RPC}"
ANVIL_PORT="${ANVIL_PORT:-8545}"

# Default Anvil account 0
DEFAULT_WALLET="0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"

echo "Starting Anvil fork at block $FORK_BLOCK from $RPC_URL..."

anvil \
    --fork-url "$RPC_URL" \
    --fork-block-number "$FORK_BLOCK" \
    --port "$ANVIL_PORT" \
    --balance 100 \
    --accounts 10 \
    --silent &

ANVIL_PID=$!
export ANVIL_PID

# Wait for Anvil to be ready (up to 30 seconds)
echo "Waiting for Anvil to start (PID: $ANVIL_PID)..."
MAX_RETRIES=60
RETRY_COUNT=0
while ! curl -sf -X POST \
    -H "Content-Type: application/json" \
    -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
    "http://localhost:$ANVIL_PORT" > /dev/null 2>&1; do

    RETRY_COUNT=$((RETRY_COUNT + 1))
    if [ "$RETRY_COUNT" -ge "$MAX_RETRIES" ]; then
        echo "ERROR: Anvil failed to start after $MAX_RETRIES retries"
        kill "$ANVIL_PID" 2>/dev/null || true
        exit 1
    fi
    sleep 0.5
done

echo "Anvil is ready on port $ANVIL_PORT (PID: $ANVIL_PID)"

# Verify the fork block
BLOCK_HEX=$(curl -sf -X POST \
    -H "Content-Type: application/json" \
    -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
    "http://localhost:$ANVIL_PORT" | jq -r '.result')
echo "Current block: $BLOCK_HEX"

# Verify default wallet balance
BALANCE=$(cast balance "$DEFAULT_WALLET" --rpc-url "http://localhost:$ANVIL_PORT" --ether 2>/dev/null || echo "unknown")
echo "Default wallet ($DEFAULT_WALLET) balance: $BALANCE ETH"

echo "ANVIL_PID=$ANVIL_PID"
