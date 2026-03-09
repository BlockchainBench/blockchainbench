# Supply USDC to Aave V3

## Objective

Supply 10,000 USDC to the Aave V3 Pool on a forked Ethereum mainnet.

## Environment

- **Network:** Ethereum mainnet fork at block 21,000,000 (Anvil)
- **RPC:** http://localhost:8545
- **Wallet:** Default Anvil account (0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266) with 100 ETH and 100,000 USDC

## Key Addresses

- **Aave V3 Pool:** 0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2
- **USDC:** 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
- **aUSDC (Aave V3 aToken):** 0x98C23E9d8f34FEFb1B7BD6a91B7FF122F4e16F5c

## Requirements

1. Approve the Aave V3 Pool to spend 10,000 USDC (10000e6 = 10,000,000,000).
2. Call `supply(address asset, uint256 amount, address onBehalfOf, uint16 referralCode)` on the Aave V3 Pool:
   - asset: USDC address
   - amount: 10,000,000,000 (10,000 USDC)
   - onBehalfOf: your wallet address
   - referralCode: 0

## Success Criteria

- The wallet's aUSDC balance is greater than 0 after the supply.
