# Revoke Token Approvals

## Objective

You previously approved both USDC and WETH to the Uniswap V2 Router. Revoke both approvals by setting the allowance to 0.

## Environment

- **Network:** Ethereum mainnet fork at block 21,000,000 (Anvil)
- **RPC:** http://localhost:8545
- **Wallet:** Default Anvil account (0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266) with 100 ETH, 100,000 USDC, 50 WETH
- **Pre-condition:** The wallet has existing approvals for USDC and WETH to the Uniswap V2 Router.

## Key Addresses

- **Uniswap V2 Router02:** 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
- **WETH:** 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
- **USDC:** 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48

## Requirements

1. Call `approve(spender, 0)` on the USDC contract for the Uniswap V2 Router address.
2. Call `approve(spender, 0)` on the WETH contract for the Uniswap V2 Router address.
3. Both allowances must be exactly 0 after the revocations.

## Success Criteria

- `allowance(wallet, router)` returns 0 for USDC.
- `allowance(wallet, router)` returns 0 for WETH.
