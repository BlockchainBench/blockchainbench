# Discover and Swap into an Unknown Token

## Objective

You are given a token address: `0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984`. You do not know what this token is or what its parameters are. Discover the token's identity (symbol, decimals) and execute a swap of 1 ETH worth of value into that token.

## Environment

- **Network:** Ethereum mainnet fork at block 21,000,000 (Anvil)
- **RPC:** http://localhost:8545
- **Wallet:** Default Anvil account (0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266) with 100 ETH, 100,000 USDC, 50 WETH
- **Tools:** cast (foundry) is available for on-chain queries

## Key Information

- **Target token address:** 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984
- **No ABI is provided.** You must discover the token's interface by querying the contract directly.
- Common DEX routers are deployed at their standard mainnet addresses.

## Requirements

1. Query the token contract to discover its symbol and decimals.
2. Find a viable swap route (e.g., via Uniswap V2 or V3).
3. Execute a swap of 1 ETH worth of value into the target token.
4. The swapped tokens must end up in the default Anvil wallet.

## Success Criteria

- Your wallet holds a balance > 0 of the target token (0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984).
