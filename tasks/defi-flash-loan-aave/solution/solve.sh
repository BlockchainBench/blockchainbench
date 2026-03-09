#!/bin/bash
set -euo pipefail

source /blockchainbench/shared/start-anvil.sh
source /blockchainbench/shared/setup-wallet.sh

# Addresses
WALLET="0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
WALLET_KEY="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
AAVE_POOL="0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2"
USDC="0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48"
RPC="http://localhost:8545"

FLASH_AMOUNT="1000000000000"  # 1,000,000 USDC (6 decimals)
PREMIUM_AMOUNT="500000"       # 0.05% premium = 500 USDC

echo "=== Deploying FlashLoanReceiver contract ==="
DEPLOY_OUTPUT=$(forge create \
    /task/contracts/FlashLoanReceiver.sol:FlashLoanReceiver \
    --constructor-args "$AAVE_POOL" \
    --private-key "$WALLET_KEY" \
    --rpc-url "$RPC" \
    --json)

RECEIVER_ADDRESS=$(echo "$DEPLOY_OUTPUT" | jq -r '.deployedTo')
echo "FlashLoanReceiver deployed at: $RECEIVER_ADDRESS"

echo "=== Funding receiver with USDC for premium ==="
# Send enough USDC to cover the premium (500 USDC + buffer)
cast send "$USDC" \
    "transfer(address,uint256)" \
    "$RECEIVER_ADDRESS" \
    "1000000"  \
    --private-key "$WALLET_KEY" \
    --rpc-url "$RPC"
echo "Funded receiver with 1 USDC (premium buffer)"

# Actually need 500 USDC for the premium
cast send "$USDC" \
    "transfer(address,uint256)" \
    "$RECEIVER_ADDRESS" \
    "$PREMIUM_AMOUNT" \
    --private-key "$WALLET_KEY" \
    --rpc-url "$RPC"
echo "Funded receiver with 500 USDC for premium"

echo "=== Executing flash loan ==="
cast send "$RECEIVER_ADDRESS" \
    "requestFlashLoan(address,uint256)" \
    "$USDC" \
    "$FLASH_AMOUNT" \
    --private-key "$WALLET_KEY" \
    --rpc-url "$RPC"

echo "=== Flash loan executed ==="

# Verify
EXECUTED=$(cast call "$RECEIVER_ADDRESS" "flashLoanExecuted()(bool)" --rpc-url "$RPC")
echo "Flash loan executed: $EXECUTED"

PREMIUM=$(cast call "$RECEIVER_ADDRESS" "lastPremium()(uint256)" --rpc-url "$RPC")
echo "Last premium: $PREMIUM"
