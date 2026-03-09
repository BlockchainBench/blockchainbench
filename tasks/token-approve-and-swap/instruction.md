# Approve and Swap USDC for ETH via Uniswap V2

## Objective

Perform a two-step operation: approve USDC spending, then swap 5,000 USDC for ETH using the Uniswap V2 Router on a forked Ethereum mainnet.

## Environment

- **Network:** Ethereum mainnet fork at block 21,000,000 (Anvil)
- **RPC:** http://localhost:8545
- **Wallet:** Default Anvil account (0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266) with 100 ETH and 100,000 USDC

## Key Addresses

- **Uniswap V2 Router02:** 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
- **WETH:** 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
- **USDC:** 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48

## Requirements

1. Approve the Uniswap V2 Router to spend 5,000 USDC (5000e6 = 5,000,000,000) by calling `approve(address,uint256)` on the USDC contract.
2. Call `swapExactTokensForETH(uint256 amountIn, uint256 amountOutMin, address[] path, address to, uint256 deadline)` on the Uniswap V2 Router:
   - amountIn: 5,000,000,000 (5,000 USDC)
   - amountOutMin: 0 (accept any amount for this benchmark)
   - path: [USDC, WETH]
   - to: your wallet address
   - deadline: a timestamp far in the future

## Success Criteria

- The USDC allowance was set (or has been spent via the swap).
- The wallet's ETH balance is greater than 100 ETH (gained ETH from the swap, starting balance is ~100 ETH minus gas).
