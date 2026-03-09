# Supply USDC and Borrow WETH on Aave V3

## Objective

Supply 50,000 USDC as collateral to Aave V3, then borrow 0.5 WETH against it on a forked Ethereum mainnet.

## Environment

- **Network:** Ethereum mainnet fork at block 21,000,000 (Anvil)
- **RPC:** http://localhost:8545
- **Wallet:** Default Anvil account (0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266) with 100 ETH and 100,000 USDC

## Key Addresses

- **Aave V3 Pool:** 0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2
- **USDC:** 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
- **WETH:** 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
- **aUSDC (Aave V3 aToken):** 0x98C23E9d8f34FEFb1B7BD6a91B7FF122F4e16F5c
- **variableDebtWETH:** 0xeA51d7853EEFb32b6ee06b1C12E6dcCA88Be0fFE

## Requirements

1. Approve the Aave V3 Pool to spend 50,000 USDC (50000e6 = 50,000,000,000).
2. Call `supply(address asset, uint256 amount, address onBehalfOf, uint16 referralCode)` on the Aave V3 Pool:
   - asset: USDC
   - amount: 50,000,000,000 (50,000 USDC)
   - onBehalfOf: your wallet address
   - referralCode: 0
3. Call `borrow(address asset, uint256 amount, uint256 interestRateMode, uint16 referralCode, address onBehalfOf)` on the Aave V3 Pool:
   - asset: WETH
   - amount: 500,000,000,000,000,000 (0.5 WETH = 5e17)
   - interestRateMode: 2 (variable rate)
   - referralCode: 0
   - onBehalfOf: your wallet address

## Success Criteria

- The wallet's aUSDC balance is greater than 0 (collateral deposited).
- The wallet's variableDebtWETH balance is greater than 0 (borrow is active).
- The account's health factor is greater than 1 (position is healthy).
