#!/bin/bash
set -euo pipefail

source /blockchainbench/shared/start-anvil.sh
source /blockchainbench/shared/setup-wallet.sh

# Addresses
WALLET="0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
WALLET_KEY="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
AAVE_POOL="0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2"
USDC="0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48"
WETH="0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"
AUSDC="0x98C23E9d8f34FEFb1B7BD6a91B7FF122F4e16F5c"
VAR_DEBT_WETH="0xeA51d7853EEFb32b6ee06b1C12E6dcCA88Be0fFE"
RPC="http://localhost:8545"

SUPPLY_AMOUNT="50000000000"         # 50,000 USDC (6 decimals)
BORROW_AMOUNT="500000000000000000"  # 0.5 WETH (18 decimals)

echo "=== Step 1: Approve Aave Pool to spend USDC ==="
cast send "$USDC" "approve(address,uint256)" \
    "$AAVE_POOL" "$SUPPLY_AMOUNT" \
    --private-key "$WALLET_KEY" \
    --rpc-url "$RPC"

echo "=== Step 2: Supply 50,000 USDC to Aave V3 ==="
cast send "$AAVE_POOL" \
    "supply(address,uint256,address,uint16)" \
    "$USDC" "$SUPPLY_AMOUNT" "$WALLET" 0 \
    --private-key "$WALLET_KEY" \
    --rpc-url "$RPC"

echo "=== Step 3: Borrow 0.5 WETH from Aave V3 ==="
cast send "$AAVE_POOL" \
    "borrow(address,uint256,uint256,uint16,address)" \
    "$WETH" "$BORROW_AMOUNT" 2 0 "$WALLET" \
    --private-key "$WALLET_KEY" \
    --rpc-url "$RPC"

echo "=== Supply + Borrow complete ==="

# Verify
AUSDC_BAL=$(cast call "$AUSDC" "balanceOf(address)(uint256)" "$WALLET" --rpc-url "$RPC")
echo "aUSDC balance: $AUSDC_BAL"

DEBT_BAL=$(cast call "$VAR_DEBT_WETH" "balanceOf(address)(uint256)" "$WALLET" --rpc-url "$RPC")
echo "variableDebtWETH balance: $DEBT_BAL"

# Check health factor via getUserAccountData
ACCOUNT_DATA=$(cast call "$AAVE_POOL" \
    "getUserAccountData(address)(uint256,uint256,uint256,uint256,uint256,uint256)" \
    "$WALLET" --rpc-url "$RPC")
echo "Account data: $ACCOUNT_DATA"
