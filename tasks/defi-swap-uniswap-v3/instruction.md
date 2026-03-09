# Swap ETH for USDC via Uniswap V3

## Objective

Swap exactly 1 ETH for USDC using the Uniswap V3 SwapRouter's `exactInputSingle` function on a forked Ethereum mainnet.

## Environment

- **Network:** Ethereum mainnet fork at block 21,000,000 (Anvil)
- **RPC:** http://localhost:8545
- **Wallet:** Default Anvil account (0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266) with 100 ETH

## Key Addresses

- **Uniswap V3 SwapRouter:** 0xE592427A0AEce92De3Edee1F18E0157C05861564
- **WETH:** 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
- **USDC:** 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48

## Requirements

1. Wrap 1 ETH into WETH by calling the WETH contract's `deposit()` function with 1 ETH as msg.value.
2. Approve the Uniswap V3 SwapRouter to spend 1 WETH.
3. Call `exactInputSingle` on the SwapRouter with the following parameters:
   - tokenIn: WETH
   - tokenOut: USDC
   - fee: 3000 (0.3% fee tier)
   - recipient: your wallet address
   - deadline: a timestamp far in the future
   - amountIn: 1e18 (1 WETH)
   - amountOutMinimum: 0
   - sqrtPriceLimitX96: 0
4. The recipient must be the default Anvil wallet.

## Success Criteria

- The wallet's USDC balance is greater than 0 after the swap.
