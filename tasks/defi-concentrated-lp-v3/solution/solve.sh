#!/bin/bash
set -euo pipefail

source /blockchainbench/shared/start-anvil.sh
source /blockchainbench/shared/setup-wallet.sh

# Addresses
WALLET="0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
WALLET_KEY="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
POSITION_MANAGER="0xC36442b4a4522E871399CD717aBDD847Ab11FE88"
WETH="0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"
USDC="0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48"
RPC="http://localhost:8545"

DEADLINE=9999999999

# USDC < WETH by address, so token0 = USDC, token1 = WETH
# Fee tier: 3000 (0.3%), tick spacing = 60

# Amounts: 5,000 USDC and 2 WETH
USDC_AMOUNT="5000000000"        # 5,000 * 1e6
WETH_AMOUNT="2000000000000000000"  # 2 * 1e18

# Tick range: wide range around current price
# At block 21M, ETH ~$2500, current tick for USDC/WETH 0.3% pool is approximately -201120
# Use a wide range: -207720 to -194520 (multiples of 60)
TICK_LOWER="-207720"
TICK_UPPER="-194520"

echo "=== Approving USDC to Position Manager ==="
cast send "$USDC" \
    "approve(address,uint256)" \
    "$POSITION_MANAGER" \
    "$USDC_AMOUNT" \
    --private-key "$WALLET_KEY" \
    --rpc-url "$RPC"

echo "=== Approving WETH to Position Manager ==="
cast send "$WETH" \
    "approve(address,uint256)" \
    "$POSITION_MANAGER" \
    "$WETH_AMOUNT" \
    --private-key "$WALLET_KEY" \
    --rpc-url "$RPC"

echo "=== Minting concentrated liquidity position ==="
# mint((address token0, address token1, uint24 fee, int24 tickLower, int24 tickUpper,
#        uint256 amount0Desired, uint256 amount1Desired, uint256 amount0Min, uint256 amount1Min,
#        address recipient, uint256 deadline))
cast send "$POSITION_MANAGER" \
    "mint((address,address,uint24,int24,int24,uint256,uint256,uint256,uint256,address,uint256))" \
    "($USDC,$WETH,3000,$TICK_LOWER,$TICK_UPPER,$USDC_AMOUNT,$WETH_AMOUNT,0,0,$WALLET,$DEADLINE)" \
    --private-key "$WALLET_KEY" \
    --rpc-url "$RPC"

echo "=== Position minted ==="

# Verify: check NFT balance
NFT_BAL=$(cast call "$POSITION_MANAGER" "balanceOf(address)(uint256)" "$WALLET" --rpc-url "$RPC")
echo "NFT position balance: $NFT_BAL"
