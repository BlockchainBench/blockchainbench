#!/bin/bash
set -euo pipefail

source /blockchainbench/shared/start-anvil.sh
source /blockchainbench/shared/setup-wallet.sh

# Addresses
WALLET="0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
WALLET_KEY="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
UNISWAP_V2_ROUTER="0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D"
USDC="0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48"
RPC="http://localhost:8545"

DEADLINE=9999999999
USDC_AMOUNT="5000000000"  # 5,000 USDC (6 decimals)
ETH_AMOUNT="2ether"        # ~2 ETH to pair with USDC

echo "=== Approving USDC to Uniswap V2 Router ==="
cast send "$USDC" \
    "approve(address,uint256)" \
    "$UNISWAP_V2_ROUTER" \
    "$USDC_AMOUNT" \
    --private-key "$WALLET_KEY" \
    --rpc-url "$RPC"

echo "=== Adding ETH/USDC liquidity via Uniswap V2 ==="
cast send "$UNISWAP_V2_ROUTER" \
    "addLiquidityETH(address,uint256,uint256,uint256,address,uint256)" \
    "$USDC" \
    "$USDC_AMOUNT" \
    0 \
    0 \
    "$WALLET" \
    "$DEADLINE" \
    --value "$ETH_AMOUNT" \
    --private-key "$WALLET_KEY" \
    --rpc-url "$RPC"

echo "=== Liquidity added ==="

# Verify: get the pair address and check LP balance
FACTORY="0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f"
WETH="0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"
PAIR=$(cast call "$FACTORY" "getPair(address,address)(address)" "$USDC" "$WETH" --rpc-url "$RPC")
echo "Pair address: $PAIR"

LP_BAL=$(cast call "$PAIR" "balanceOf(address)(uint256)" "$WALLET" --rpc-url "$RPC")
echo "LP token balance: $LP_BAL"
