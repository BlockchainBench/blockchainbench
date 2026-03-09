# Create Concentrated Liquidity Position on Uniswap V3

## Objective

Create a concentrated liquidity position on Uniswap V3 for the ETH/USDC pair with a specific tick range.

## Environment

- **Network:** Ethereum mainnet fork at block 21,000,000 (Anvil)
- **RPC:** http://localhost:8545
- **Wallet:** Default Anvil account (0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266) with 100 ETH, 100,000 USDC, 50 WETH

## Key Addresses

- **Uniswap V3 NonfungiblePositionManager:** 0xC36442b4a4522E871399CD717aBDD847Ab11FE88
- **WETH:** 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
- **USDC:** 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48

## Requirements

1. Wrap some ETH into WETH (if needed -- you already have 50 WETH).
2. Approve both WETH and USDC to the NonfungiblePositionManager.
3. Call `mint()` on the NonfungiblePositionManager with:
   - **token0/token1:** Ordered by address (USDC < WETH, so token0 = USDC, token1 = WETH)
   - **fee:** 3000 (0.3% fee tier, the standard ETH/USDC pool)
   - **tickLower/tickUpper:** Choose a range around the current price. Ticks must be multiples of the tick spacing (60 for the 0.3% pool).
   - **amount0Desired/amount1Desired:** Reasonable amounts of USDC and WETH
   - **amount0Min/amount1Min:** 0 (acceptable for this benchmark)
   - **recipient:** Your wallet address
   - **deadline:** Far in the future

## Success Criteria

- The wallet holds at least one NFT position (balanceOf > 0 on the NonfungiblePositionManager).
