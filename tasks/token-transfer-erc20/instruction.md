# Transfer USDC to a Recipient

## Objective

Transfer 1,000 USDC to a target address.

## Environment

- **Network:** Ethereum mainnet fork at block 21,000,000 (Anvil)
- **RPC:** http://localhost:8545
- **Wallet:** Default Anvil account (0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266) with 100 ETH
- **Note:** The wallet is pre-funded with 100,000 USDC via setup-wallet.sh.

## Key Addresses

- **USDC:** 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
- **Recipient:** 0x000000000000000000000000000000000000dEaD

## Requirements

1. Transfer exactly 1,000 USDC (1,000 * 10^6 = 1,000,000,000 raw units, since USDC has 6 decimals) to the recipient address.
2. Use the standard ERC20 `transfer(address,uint256)` function.

## Success Criteria

- The recipient's USDC balance is exactly 1,000 USDC (1,000,000,000 raw units).
