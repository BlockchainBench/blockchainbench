#!/bin/bash
set -euo pipefail

source /blockchainbench/shared/start-anvil.sh
source /blockchainbench/shared/setup-wallet.sh

# Addresses
WALLET="0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
WALLET_KEY="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
USDC="0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48"
TARGET="0x000000000000000000000000000000000000dEaD"
RPC="http://localhost:8545"

# 1000 USDC = 1000 * 10^6 = 1000000000 (USDC has 6 decimals)
AMOUNT="1000000000"

echo "=== Transferring 1000 USDC to $TARGET ==="

cast send "$USDC" \
    "transfer(address,uint256)" \
    "$TARGET" \
    "$AMOUNT" \
    --private-key "$WALLET_KEY" \
    --rpc-url "$RPC"

echo "=== Transfer complete ==="

# Verify
TARGET_BAL=$(cast call "$USDC" "balanceOf(address)(uint256)" "$TARGET" --rpc-url "$RPC")
echo "Recipient USDC balance: $TARGET_BAL"
