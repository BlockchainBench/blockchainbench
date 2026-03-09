#!/usr/bin/env bash
# Fund and configure the agent wallet for a task run.
# Seeds the default Anvil wallet with USDC, WETH, and WBTC.
set -euo pipefail

ANVIL_PORT="${ANVIL_PORT:-8545}"
RPC="http://localhost:$ANVIL_PORT"

# Default Anvil account 0
WALLET="0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
WALLET_KEY="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"

# Contract addresses
USDC="0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48"
WETH="0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"
WBTC="0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599"

# Whale addresses
USDC_WHALE="0x47ac0Fb4F2D84898e4D9E7b4DaB3C24507a6D503"  # Binance
WBTC_WHALE="0x9ff58f4fFB29fA2266Ab25e75e2A8b3503311656"

# ERC20 transfer function signature
TRANSFER_SIG="transfer(address,uint256)"

echo "=== Setting up wallet: $WALLET ==="

# --- USDC: 100,000 USDC (6 decimals) ---
echo ""
echo "--- Seeding 100,000 USDC ---"
USDC_AMOUNT="100000000000"  # 100,000 * 1e6

# Impersonate USDC whale
cast rpc anvil_impersonateAccount "$USDC_WHALE" --rpc-url "$RPC" > /dev/null
echo "Impersonated USDC whale: $USDC_WHALE"

# Transfer USDC
cast send "$USDC" "$TRANSFER_SIG" "$WALLET" "$USDC_AMOUNT" \
    --from "$USDC_WHALE" \
    --rpc-url "$RPC" \
    --unlocked > /dev/null
echo "Transferred 100,000 USDC to wallet"

# Stop impersonation
cast rpc anvil_stopImpersonatingAccount "$USDC_WHALE" --rpc-url "$RPC" > /dev/null

# --- WETH: 50 WETH (deposit 50 ETH) ---
echo ""
echo "--- Seeding 50 WETH ---"
WETH_AMOUNT="50000000000000000000"  # 50 * 1e18

# Deposit ETH into WETH contract (calling deposit() payable)
cast send "$WETH" "deposit()" \
    --value "$WETH_AMOUNT" \
    --from "$WALLET" \
    --private-key "$WALLET_KEY" \
    --rpc-url "$RPC" > /dev/null
echo "Deposited 50 ETH -> 50 WETH"

# --- WBTC: 10 WBTC (8 decimals) ---
echo ""
echo "--- Seeding 10 WBTC ---"
WBTC_AMOUNT="1000000000"  # 10 * 1e8

# Impersonate WBTC whale
cast rpc anvil_impersonateAccount "$WBTC_WHALE" --rpc-url "$RPC" > /dev/null
echo "Impersonated WBTC whale: $WBTC_WHALE"

# Transfer WBTC
cast send "$WBTC" "$TRANSFER_SIG" "$WALLET" "$WBTC_AMOUNT" \
    --from "$WBTC_WHALE" \
    --rpc-url "$RPC" \
    --unlocked > /dev/null
echo "Transferred 10 WBTC to wallet"

# Stop impersonation
cast rpc anvil_stopImpersonatingAccount "$WBTC_WHALE" --rpc-url "$RPC" > /dev/null

# --- Verify balances ---
echo ""
echo "=== Verifying balances ==="

ETH_BAL=$(cast balance "$WALLET" --rpc-url "$RPC" --ether)
echo "ETH:  $ETH_BAL"

USDC_BAL=$(cast call "$USDC" "balanceOf(address)(uint256)" "$WALLET" --rpc-url "$RPC")
echo "USDC: $USDC_BAL (raw, 6 decimals)"

WETH_BAL=$(cast call "$WETH" "balanceOf(address)(uint256)" "$WALLET" --rpc-url "$RPC")
echo "WETH: $WETH_BAL (raw, 18 decimals)"

WBTC_BAL=$(cast call "$WBTC" "balanceOf(address)(uint256)" "$WALLET" --rpc-url "$RPC")
echo "WBTC: $WBTC_BAL (raw, 8 decimals)"

echo ""
echo "=== Wallet setup complete ==="
