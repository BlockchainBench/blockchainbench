# Execute a Flash Loan on Aave V3

## Objective

Execute a flash loan of 1,000,000 USDC on Aave V3. Deploy a flash loan receiver contract that borrows the USDC, performs an operation, and repays the loan with the premium.

## Environment

- **Network:** Ethereum mainnet fork at block 21,000,000 (Anvil)
- **RPC:** http://localhost:8545
- **Wallet:** Default Anvil account (0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266) with 100 ETH, 100,000 USDC, 50 WETH
- **Tools:** foundry (forge, cast) is available for compiling and deploying contracts

## Key Addresses

- **Aave V3 Pool:** 0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2
- **USDC:** 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48

## Requirements

1. Write and deploy a flash loan receiver contract that implements `IFlashLoanSimpleReceiver`.
2. The receiver contract must:
   - Receive the flash-loaned USDC in `executeOperation()`.
   - Approve the Aave Pool to pull back the loan amount + premium.
   - Return `true` from `executeOperation()`.
3. Fund the receiver contract with enough USDC to cover the flash loan premium (0.05% = 500 USDC for a 1M loan).
4. Call `flashLoanSimple()` on the Aave V3 Pool, targeting your deployed receiver contract.

## Success Criteria

- The flash loan executes successfully (no revert).
- The receiver contract has no outstanding debt.
- The receiver contract's `executeOperation` was called (verified by checking contract state or events).
