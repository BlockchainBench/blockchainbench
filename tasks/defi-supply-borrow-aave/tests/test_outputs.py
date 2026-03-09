"""Tests for defi-supply-borrow-aave task."""

import pytest
from libs.constants import DEFAULT_ANVIL_ADDRESS, AAVE_V3_POOL, ERC20_ABI
from libs.web3_utils import get_web3

AUSDC_ADDRESS = "0x98C23E9d8f34FEFb1B7BD6a91B7FF122F4e16F5c"
VARIABLE_DEBT_WETH_ADDRESS = "0xeA51d7853EEFb32b6ee06b1C12E6dcCA88Be0fFE"

AAVE_POOL_ABI = [
    {
        "inputs": [{"name": "user", "type": "address"}],
        "name": "getUserAccountData",
        "outputs": [
            {"name": "totalCollateralBase", "type": "uint256"},
            {"name": "totalDebtBase", "type": "uint256"},
            {"name": "availableBorrowsBase", "type": "uint256"},
            {"name": "currentLiquidationThreshold", "type": "uint256"},
            {"name": "ltv", "type": "uint256"},
            {"name": "healthFactor", "type": "uint256"},
        ],
        "stateMutability": "view",
        "type": "function",
    }
]


@pytest.fixture
def w3():
    return get_web3()


@pytest.fixture
def ausdc(w3):
    return w3.eth.contract(
        address=w3.to_checksum_address(AUSDC_ADDRESS), abi=ERC20_ABI
    )


@pytest.fixture
def var_debt_weth(w3):
    return w3.eth.contract(
        address=w3.to_checksum_address(VARIABLE_DEBT_WETH_ADDRESS), abi=ERC20_ABI
    )


@pytest.fixture
def aave_pool(w3):
    return w3.eth.contract(
        address=w3.to_checksum_address(AAVE_V3_POOL), abi=AAVE_POOL_ABI
    )


def test_ausdc_balance_greater_than_zero(ausdc):
    """Wallet should hold aUSDC after supplying collateral."""
    balance = ausdc.functions.balanceOf(DEFAULT_ANVIL_ADDRESS).call()
    assert balance > 0, f"aUSDC balance should be > 0, got {balance}"


def test_variable_debt_weth_greater_than_zero(var_debt_weth):
    """Wallet should have variable debt WETH after borrowing."""
    balance = var_debt_weth.functions.balanceOf(DEFAULT_ANVIL_ADDRESS).call()
    assert balance > 0, f"variableDebtWETH balance should be > 0, got {balance}"


def test_health_factor_greater_than_one(aave_pool):
    """Position health factor should be > 1 (not liquidatable)."""
    account_data = aave_pool.functions.getUserAccountData(
        DEFAULT_ANVIL_ADDRESS
    ).call()
    health_factor = account_data[5]  # 6th return value
    # Health factor is in WAD (1e18 = 1.0)
    assert health_factor > 10**18, (
        f"Health factor should be > 1e18, got {health_factor}"
    )
