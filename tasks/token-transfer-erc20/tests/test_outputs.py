"""Tests for token-transfer-erc20 task."""

import pytest
from web3 import Web3

from libs.constants import USDC_ADDRESS, ERC20_ABI
from libs.web3_utils import get_web3


TARGET = "0x000000000000000000000000000000000000dEaD"
EXPECTED_AMOUNT = 1_000_000_000  # 1000 USDC in raw units (6 decimals)


def test_recipient_usdc_balance():
    """The recipient should have exactly 1000 USDC (1,000,000,000 raw units)."""
    w3 = get_web3()
    usdc = w3.eth.contract(
        address=Web3.to_checksum_address(USDC_ADDRESS),
        abi=ERC20_ABI,
    )
    balance = usdc.functions.balanceOf(
        Web3.to_checksum_address(TARGET)
    ).call()
    assert balance == EXPECTED_AMOUNT, (
        f"Expected recipient USDC balance {EXPECTED_AMOUNT}, got {balance}"
    )
