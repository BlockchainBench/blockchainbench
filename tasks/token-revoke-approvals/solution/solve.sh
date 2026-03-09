#!/bin/bash
set -euo pipefail

source /blockchainbench/shared/start-anvil.sh
source /blockchainbench/shared/setup-wallet.sh

# Addresses
WALLET="0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
WALLET_KEY="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
UNISWAP_V2_ROUTER="0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D"
USDC="0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48"
WETH="0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"
RPC="http://localhost:8545"

# Step 1: Grant approvals first (simulating the pre-condition)
echo "=== Setting up: Granting approvals ==="
MAX_UINT256="115792089237316195423570985008687907853269984665640564039457584007913129639935"

cast send "$USDC" \
    "approve(address,uint256)" \
    "$UNISWAP_V2_ROUTER" \
    "$MAX_UINT256" \
    --private-key "$WALLET_KEY" \
    --rpc-url "$RPC"

cast send "$WETH" \
    "approve(address,uint256)" \
    "$UNISWAP_V2_ROUTER" \
    "$MAX_UINT256" \
    --private-key "$WALLET_KEY" \
    --rpc-url "$RPC"

echo "Approvals granted. Verifying..."
USDC_ALLOWANCE=$(cast call "$USDC" "allowance(address,address)(uint256)" "$WALLET" "$UNISWAP_V2_ROUTER" --rpc-url "$RPC")
echo "USDC allowance before revoke: $USDC_ALLOWANCE"
WETH_ALLOWANCE=$(cast call "$WETH" "allowance(address,address)(uint256)" "$WALLET" "$UNISWAP_V2_ROUTER" --rpc-url "$RPC")
echo "WETH allowance before revoke: $WETH_ALLOWANCE"

# Step 2: Revoke approvals
echo "=== Revoking USDC approval ==="
cast send "$USDC" \
    "approve(address,uint256)" \
    "$UNISWAP_V2_ROUTER" \
    0 \
    --private-key "$WALLET_KEY" \
    --rpc-url "$RPC"

echo "=== Revoking WETH approval ==="
cast send "$WETH" \
    "approve(address,uint256)" \
    "$UNISWAP_V2_ROUTER" \
    0 \
    --private-key "$WALLET_KEY" \
    --rpc-url "$RPC"

echo "=== Approvals revoked ==="

# Verify
USDC_ALLOWANCE=$(cast call "$USDC" "allowance(address,address)(uint256)" "$WALLET" "$UNISWAP_V2_ROUTER" --rpc-url "$RPC")
echo "USDC allowance after revoke: $USDC_ALLOWANCE"

WETH_ALLOWANCE=$(cast call "$WETH" "allowance(address,address)(uint256)" "$WALLET" "$UNISWAP_V2_ROUTER" --rpc-url "$RPC")
echo "WETH allowance after revoke: $WETH_ALLOWANCE"
