"""Tests for token-discover-and-swap task."""

import pytest
from web3 import Web3

from libs.constants import DEFAULT_ANVIL_ADDRESS, UNI_ADDRESS
from libs.web3_utils import get_erc20_balance


WALLET = DEFAULT_ANVIL_ADDRESS
TARGET_TOKEN = UNI_ADDRESS  # 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984


def test_target_token_balance_greater_than_zero():
    """After discovering and swapping, the wallet should hold the target token."""
    balance = get_erc20_balance(TARGET_TOKEN, WALLET)
    assert balance > 0, f"Expected target token balance > 0, got {balance}"
