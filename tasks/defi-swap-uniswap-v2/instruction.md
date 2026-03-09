# Swap ETH for USDC via Uniswap V2

## Objective

Swap exactly 1 ETH for USDC using the Uniswap V2 Router on a forked Ethereum mainnet.

## Environment

- **Network:** Ethereum mainnet fork at block 21,000,000 (Anvil)
- **RPC:** http://localhost:8545
- **Wallet:** Default Anvil account (0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266) with 100 ETH

## Key Addresses

- **Uniswap V2 Router02:** 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
- **WETH:** 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
- **USDC:** 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48

## Requirements

1. Use the Uniswap V2 Router's `swapExactETHForTokens` function.
2. Swap exactly 1 ETH (sent as msg.value).
3. The swap path must be WETH -> USDC.
4. The recipient must be the default Anvil wallet.
5. Set a deadline far enough in the future that the transaction succeeds.
6. Accept any amount of USDC output (amountOutMin can be 0 for this benchmark).

## Success Criteria

- The wallet's USDC balance is greater than 0 after the swap.
- The wallet's ETH balance is less than the original 100 ETH.
