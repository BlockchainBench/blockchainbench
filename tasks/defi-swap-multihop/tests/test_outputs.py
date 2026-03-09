"""Tests for defi-swap-multihop task."""

import pytest
from libs.constants import (
    USDC_ADDRESS,
    WBTC_ADDRESS,
    DEFAULT_ANVIL_ADDRESS,
    ERC20_ABI,
)
from libs.web3_utils import get_web3


@pytest.fixture
def w3():
    return get_web3()


@pytest.fixture
def usdc(w3):
    return w3.eth.contract(address=USDC_ADDRESS, abi=ERC20_ABI)


@pytest.fixture
def wbtc(w3):
    return w3.eth.contract(address=WBTC_ADDRESS, abi=ERC20_ABI)


def test_usdc_balance_greater_than_zero(usdc):
    """Wallet should hold USDC after multi-hop swap."""
    balance = usdc.functions.balanceOf(DEFAULT_ANVIL_ADDRESS).call()
    assert balance > 0, f"USDC balance should be > 0, got {balance}"


def test_wbtc_not_held(wbtc):
    """Intermediate token (WBTC) should not be held by wallet after multi-hop swap.

    The setup-wallet script seeds 10 WBTC, so we check the balance hasn't increased
    beyond the initial seed amount (10 WBTC = 10e8 = 1,000,000,000).
    """
    balance = wbtc.functions.balanceOf(DEFAULT_ANVIL_ADDRESS).call()
    initial_wbtc = 10 * 10**8  # 10 WBTC seeded by setup-wallet.sh
    assert balance <= initial_wbtc, (
        f"WBTC balance should not exceed initial seed ({initial_wbtc}), got {balance}"
    )
