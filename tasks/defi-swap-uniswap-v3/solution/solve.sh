#!/bin/bash
set -euo pipefail

source /blockchainbench/shared/start-anvil.sh
source /blockchainbench/shared/setup-wallet.sh

# Addresses
WALLET="0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
WALLET_KEY="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
SWAP_ROUTER="0xE592427A0AEce92De3Edee1F18E0157C05861564"
WETH="0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"
USDC="0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48"
RPC="http://localhost:8545"

DEADLINE=9999999999
AMOUNT_IN="1000000000000000000"  # 1e18

echo "=== Step 1: Wrap 1 ETH -> WETH ==="
cast send "$WETH" "deposit()" \
    --value 1ether \
    --private-key "$WALLET_KEY" \
    --rpc-url "$RPC"

echo "=== Step 2: Approve SwapRouter to spend WETH ==="
cast send "$WETH" "approve(address,uint256)" \
    "$SWAP_ROUTER" "$AMOUNT_IN" \
    --private-key "$WALLET_KEY" \
    --rpc-url "$RPC"

echo "=== Step 3: Swap WETH -> USDC via exactInputSingle ==="
cast send "$SWAP_ROUTER" \
    "exactInputSingle((address,address,uint24,address,uint256,uint256,uint256,uint160))" \
    "($WETH,$USDC,3000,$WALLET,$DEADLINE,$AMOUNT_IN,0,0)" \
    --private-key "$WALLET_KEY" \
    --rpc-url "$RPC"

echo "=== Swap complete ==="

# Verify
USDC_BAL=$(cast call "$USDC" "balanceOf(address)(uint256)" "$WALLET" --rpc-url "$RPC")
echo "USDC balance: $USDC_BAL"
