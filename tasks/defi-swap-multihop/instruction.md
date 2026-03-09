# Multi-Hop Swap via Uniswap V3

## Objective

Perform a multi-hop swap: ETH -> WETH -> WBTC -> USDC using the Uniswap V3 SwapRouter's `exactInput` function with an encoded path on a forked Ethereum mainnet.

## Environment

- **Network:** Ethereum mainnet fork at block 21,000,000 (Anvil)
- **RPC:** http://localhost:8545
- **Wallet:** Default Anvil account (0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266) with 100 ETH

## Key Addresses

- **Uniswap V3 SwapRouter:** 0xE592427A0AEce92De3Edee1F18E0157C05861564
- **WETH:** 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
- **WBTC:** 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599
- **USDC:** 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48

## Requirements

1. Wrap 1 ETH into WETH by calling the WETH contract's `deposit()` function with 1 ETH as msg.value.
2. Approve the Uniswap V3 SwapRouter to spend 1 WETH.
3. Construct the encoded path for Uniswap V3 multi-hop: WETH (20 bytes) + fee 3000 (3 bytes) + WBTC (20 bytes) + fee 3000 (3 bytes) + USDC (20 bytes).
4. Call `exactInput` on the SwapRouter with the following parameters:
   - path: the encoded multi-hop path
   - recipient: your wallet address
   - deadline: a timestamp far in the future
   - amountIn: 1e18 (1 WETH)
   - amountOutMinimum: 0

## Success Criteria

- The wallet's USDC balance is greater than 0 after the swap.
- The wallet's WBTC balance is unchanged (intermediate token should not be held).
