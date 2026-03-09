#!/bin/bash
set -euo pipefail

source /blockchainbench/shared/start-anvil.sh
source /blockchainbench/shared/setup-wallet.sh

# Addresses
WALLET="0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
WALLET_KEY="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
AAVE_POOL="0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2"
USDC="0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48"
AUSDC="0x98C23E9d8f34FEFb1B7BD6a91B7FF122F4e16F5c"
RPC="http://localhost:8545"

SUPPLY_AMOUNT="10000000000"  # 10,000 USDC (6 decimals)

echo "=== Step 1: Approve Aave Pool to spend USDC ==="
cast send "$USDC" "approve(address,uint256)" \
    "$AAVE_POOL" "$SUPPLY_AMOUNT" \
    --private-key "$WALLET_KEY" \
    --rpc-url "$RPC"

echo "=== Step 2: Supply 10,000 USDC to Aave V3 ==="
cast send "$AAVE_POOL" \
    "supply(address,uint256,address,uint16)" \
    "$USDC" "$SUPPLY_AMOUNT" "$WALLET" 0 \
    --private-key "$WALLET_KEY" \
    --rpc-url "$RPC"

echo "=== Supply complete ==="

# Verify
AUSDC_BAL=$(cast call "$AUSDC" "balanceOf(address)(uint256)" "$WALLET" --rpc-url "$RPC")
echo "aUSDC balance: $AUSDC_BAL"
