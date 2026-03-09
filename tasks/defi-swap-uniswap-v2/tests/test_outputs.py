"""Tests for defi-swap-uniswap-v2 task."""

import pytest

from libs.constants import DEFAULT_ANVIL_ADDRESS, USDC_ADDRESS
from libs.web3_utils import get_erc20_balance, get_eth_balance


WALLET = DEFAULT_ANVIL_ADDRESS
INITIAL_ETH_BALANCE = 100.0  # Anvil default


def test_usdc_balance_greater_than_zero():
    """After swapping 1 ETH, the wallet should hold some USDC."""
    usdc_balance = get_erc20_balance(USDC_ADDRESS, WALLET)
    assert usdc_balance > 0, f"Expected USDC balance > 0, got {usdc_balance}"


def test_eth_balance_decreased():
    """After swapping 1 ETH (plus gas), ETH balance should be less than original 100."""
    eth_balance = get_eth_balance(WALLET)
    assert eth_balance < INITIAL_ETH_BALANCE, (
        f"Expected ETH balance < {INITIAL_ETH_BALANCE}, got {eth_balance}"
    )
