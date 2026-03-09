"""Tests for token-wrap-eth task."""

import pytest

from libs.constants import DEFAULT_ANVIL_ADDRESS, WETH_ADDRESS
from libs.web3_utils import get_erc20_balance


WALLET = DEFAULT_ANVIL_ADDRESS


def test_weth_balance_at_least_10():
    """After wrapping 10 ETH, the wallet should hold at least 10 WETH."""
    weth_balance = get_erc20_balance(WETH_ADDRESS, WALLET)
    assert weth_balance >= 10.0, (
        f"Expected WETH balance >= 10.0, got {weth_balance}"
    )
