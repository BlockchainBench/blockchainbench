#!/bin/bash
set -euo pipefail

source /blockchainbench/shared/start-anvil.sh
source /blockchainbench/shared/setup-wallet.sh

# Addresses
WALLET="0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
WALLET_KEY="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
TARGET_TOKEN="0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984"
WETH="0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"
UNISWAP_V2_ROUTER="0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D"
RPC="http://localhost:8545"
DEADLINE=9999999999

# Step 1: Discover the token
echo "=== Discovering token ==="
SYMBOL=$(cast call "$TARGET_TOKEN" "symbol()(string)" --rpc-url "$RPC")
echo "Symbol: $SYMBOL"

DECIMALS=$(cast call "$TARGET_TOKEN" "decimals()(uint8)" --rpc-url "$RPC")
echo "Decimals: $DECIMALS"

NAME=$(cast call "$TARGET_TOKEN" "name()(string)" --rpc-url "$RPC")
echo "Name: $NAME"

# Step 2: Check if a Uniswap V2 pair exists via WETH
FACTORY="0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f"
PAIR=$(cast call "$FACTORY" "getPair(address,address)(address)" "$TARGET_TOKEN" "$WETH" --rpc-url "$RPC")
echo "V2 Pair (WETH/$SYMBOL): $PAIR"

# Step 3: Swap 1 ETH for the target token via Uniswap V2
echo "=== Swapping 1 ETH for $SYMBOL via Uniswap V2 ==="
cast send "$UNISWAP_V2_ROUTER" \
    "swapExactETHForTokens(uint256,address[],address,uint256)" \
    0 \
    "[$WETH,$TARGET_TOKEN]" \
    "$WALLET" \
    "$DEADLINE" \
    --value 1ether \
    --private-key "$WALLET_KEY" \
    --rpc-url "$RPC"

echo "=== Swap complete ==="

# Verify
TOKEN_BAL=$(cast call "$TARGET_TOKEN" "balanceOf(address)(uint256)" "$WALLET" --rpc-url "$RPC")
echo "$SYMBOL balance: $TOKEN_BAL"
