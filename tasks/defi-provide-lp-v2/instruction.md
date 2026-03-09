# Provide ETH/USDC Liquidity on Uniswap V2

## Objective

Add liquidity to the ETH/USDC pair on Uniswap V2 by providing both ETH and USDC to the pool.

## Environment

- **Network:** Ethereum mainnet fork at block 21,000,000 (Anvil)
- **RPC:** http://localhost:8545
- **Wallet:** Default Anvil account (0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266) with 100 ETH, 100,000 USDC, 50 WETH

## Key Addresses

- **Uniswap V2 Router02:** 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
- **Uniswap V2 Factory:** 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
- **WETH:** 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
- **USDC:** 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48

## Requirements

1. Approve the Uniswap V2 Router to spend your USDC.
2. Call the Router's `addLiquidityETH` function, providing USDC as the token and ETH as msg.value.
3. Use a reasonable amount (e.g., 5,000 USDC and the corresponding amount of ETH).
4. Set `amountTokenMin` and `amountETHMin` to 0 (acceptable for this benchmark).
5. Set a deadline far enough in the future.

## Success Criteria

- Your wallet holds LP tokens for the ETH/USDC pair (balance > 0).
