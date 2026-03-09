# Contributing to BlockchainBench

## Adding a New Task

Each task lives in `tasks/<task-name>/` and must include:

| File | Purpose |
|------|---------|
| `instruction.md` | Natural-language description of what the agent should accomplish |
| `task.toml` | Configuration: fork block number, timeout, chain, initial balances |
| `Dockerfile` | Environment setup (extends `shared/base.Dockerfile`) |
| `solve.sh` | Oracle solution that a skilled human would execute |
| `test_outputs.py` or `test.sh` | Grading script that checks on-chain state after the agent runs |

## Guidelines

1. **One DeFi action per task.** Compose complex scenarios from atomic tasks.
2. **Pin the fork block.** Reproducibility requires a deterministic starting state.
3. **Grade on-chain state, not logs.** The test script should query contract state to determine success.
4. **Keep instructions protocol-agnostic where possible.** Describe the goal, not the exact function calls.
5. **Include the oracle solution.** Every task must be solvable -- `solve.sh` proves it.

## Running Tests

```bash
pytest
```

## Code Style

- Python: follow PEP 8, use type hints
- Shell: use `set -euo pipefail`, quote variables
- TOML: use snake_case keys
