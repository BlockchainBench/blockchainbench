# BlockchainBench

An open benchmark for evaluating AI agents on real DeFi tasks.

## The Problem

AI can detect 4.6 million exploits across DeFi protocols -- but it cannot swap ETH for USDC.

Security auditing, vulnerability scanning, and exploit classification have become commodity AI tasks. Yet the moment you ask an agent to *do* something on-chain -- approve a token, provide liquidity, execute a flash loan -- it falls apart. There is no standardized way to measure whether an AI agent can actually operate in DeFi.

## What is BlockchainBench?

BlockchainBench is an open benchmark suite of 13 real DeFi tasks, ranging from simple token transfers to concentrated liquidity provisioning and flash loans. Each task runs against a local Ethereum fork (via Anvil), giving agents a realistic on-chain environment without risking real funds.

Tasks are scored pass/fail with deterministic on-chain verification: either the agent completed the operation correctly, or it didn't.

## Quick Start

### With Harbor (recommended)

```bash
harbor run --benchmark blockchainbench
```

### Manual (Docker)

```bash
# Clone the repo
git clone https://github.com/BlockchainBench/blockchainbench.git
cd blockchainbench

# Build the base image
docker build -f shared/base.Dockerfile -t blockchainbench-base .

# Run a single task
cd tasks/token-wrap-eth
docker build -t bb-token-wrap-eth .
docker run --rm bb-token-wrap-eth
```

### Development

```bash
pip install -e ".[dev]"
ruff check .
pytest -v
```

## Tasks

| Task | Difficulty | Description |
|------|-----------|-------------|
| `token-wrap-eth` | Easy | Wrap 10 ETH into WETH |
| `token-transfer-erc20` | Easy | Transfer 1000 USDC to a target address |
| `defi-swap-uniswap-v2` | Easy | Swap 1 ETH for USDC via Uniswap V2 Router |
| `defi-swap-uniswap-v3` | Easy | Swap 1 ETH for USDC via Uniswap V3 SwapRouter |
| `defi-supply-aave-v3` | Easy | Supply 10,000 USDC to Aave V3 Pool |
| `token-approve-and-swap` | Medium | Approve USDC and swap 5,000 USDC for ETH via Uniswap V2 |
| `token-revoke-approvals` | Medium | Revoke USDC and WETH approvals to Uniswap V2 Router |
| `defi-provide-lp-v2` | Medium | Provide ETH/USDC liquidity on Uniswap V2 |
| `defi-supply-borrow-aave` | Medium | Supply 50,000 USDC as collateral and borrow 0.5 WETH on Aave V3 |
| `defi-swap-multihop` | Medium | Multi-hop swap ETH -> WETH -> WBTC -> USDC via Uniswap V3 |
| `defi-concentrated-lp-v3` | Hard | Create a concentrated liquidity position on Uniswap V3 |
| `defi-flash-loan-aave` | Hard | Execute a flash loan of 1,000,000 USDC on Aave V3 |
| `token-discover-and-swap` | Hard | Discover an unknown token and swap 1 ETH into it |

## Results

| Agent | Score (out of 13) | Date |
|-------|------------------|------|
| *Your agent here* | -- | -- |

To submit results, open a PR adding your agent's score with a link to reproducible logs.

## Links

- [blockchainbench.com](https://blockchainbench.com) -- Project site
- [BlockchainRL](https://blockchainrl.com) -- The company behind BlockchainBench
- [Contributing Guide](docs/CONTRIBUTING.md) -- How to add tasks and contribute

## License

Apache 2.0 -- see [LICENSE](LICENSE) for details.
