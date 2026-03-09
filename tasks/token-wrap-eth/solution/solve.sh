#!/bin/bash
set -euo pipefail

source /blockchainbench/shared/start-anvil.sh
source /blockchainbench/shared/setup-wallet.sh

# Addresses
WALLET="0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
WALLET_KEY="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
WETH="0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"
RPC="http://localhost:8545"

echo "=== Wrapping 10 ETH into WETH ==="

cast send "$WETH" "deposit()" \
    --value 10ether \
    --private-key "$WALLET_KEY" \
    --rpc-url "$RPC"

echo "=== Wrap complete ==="

# Verify
WETH_BAL=$(cast call "$WETH" "balanceOf(address)(uint256)" "$WALLET" --rpc-url "$RPC")
echo "WETH balance: $WETH_BAL"
