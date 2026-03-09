# Wrap ETH into WETH

## Objective

Wrap 10 ETH into WETH (Wrapped Ether) by depositing ETH into the WETH contract.

## Environment

- **Network:** Ethereum mainnet fork at block 21,000,000 (Anvil)
- **RPC:** http://localhost:8545
- **Wallet:** Default Anvil account (0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266) with 100 ETH

## Key Addresses

- **WETH:** 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2

## Requirements

1. Call the WETH contract's `deposit()` function with 10 ETH as msg.value.
2. The depositor must be the default Anvil wallet.

## Success Criteria

- The wallet's WETH balance is at least 10 WETH after the deposit.
