#!/bin/bash
set -euo pipefail

source /blockchainbench/shared/start-anvil.sh
source /blockchainbench/shared/setup-wallet.sh

# Addresses
WALLET="0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
WALLET_KEY="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
UNISWAP_V2_ROUTER="0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D"
WETH="0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"
USDC="0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48"
RPC="http://localhost:8545"

DEADLINE=9999999999
SWAP_AMOUNT="5000000000"  # 5,000 USDC (6 decimals)

echo "=== Step 1: Approve Uniswap V2 Router to spend USDC ==="
cast send "$USDC" "approve(address,uint256)" \
    "$UNISWAP_V2_ROUTER" "$SWAP_AMOUNT" \
    --private-key "$WALLET_KEY" \
    --rpc-url "$RPC"

echo "=== Step 2: Swap 5,000 USDC for ETH ==="
cast send "$UNISWAP_V2_ROUTER" \
    "swapExactTokensForETH(uint256,uint256,address[],address,uint256)" \
    "$SWAP_AMOUNT" \
    0 \
    "[$USDC,$WETH]" \
    "$WALLET" \
    "$DEADLINE" \
    --private-key "$WALLET_KEY" \
    --rpc-url "$RPC"

echo "=== Swap complete ==="

# Verify
ETH_BAL=$(cast balance "$WALLET" --rpc-url "$RPC" --ether)
echo "ETH balance: $ETH_BAL"

USDC_BAL=$(cast call "$USDC" "balanceOf(address)(uint256)" "$WALLET" --rpc-url "$RPC")
echo "USDC balance: $USDC_BAL"
