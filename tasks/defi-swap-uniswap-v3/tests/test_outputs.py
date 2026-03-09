"""Tests for defi-swap-uniswap-v3 task."""

import pytest
from libs.constants import USDC_ADDRESS, DEFAULT_ANVIL_ADDRESS, ERC20_ABI
from libs.web3_utils import get_web3


@pytest.fixture
def w3():
    return get_web3()


@pytest.fixture
def usdc(w3):
    return w3.eth.contract(address=USDC_ADDRESS, abi=ERC20_ABI)


def test_usdc_balance_greater_than_zero(usdc):
    """Wallet should hold USDC after swapping 1 ETH."""
    balance = usdc.functions.balanceOf(DEFAULT_ANVIL_ADDRESS).call()
    assert balance > 0, f"USDC balance should be > 0, got {balance}"
