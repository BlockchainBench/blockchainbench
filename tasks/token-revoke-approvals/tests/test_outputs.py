"""Tests for token-revoke-approvals task."""

import pytest
from web3 import Web3

from libs.constants import (
    DEFAULT_ANVIL_ADDRESS,
    ERC20_ABI,
    USDC_ADDRESS,
    WETH_ADDRESS,
    UNISWAP_V2_ROUTER,
)
from libs.web3_utils import get_web3


WALLET = DEFAULT_ANVIL_ADDRESS
ROUTER = UNISWAP_V2_ROUTER


def _get_allowance(token_address: str, owner: str, spender: str) -> int:
    """Return the raw allowance (no decimal adjustment)."""
    w3 = get_web3()
    contract = w3.eth.contract(
        address=Web3.to_checksum_address(token_address),
        abi=ERC20_ABI,
    )
    return contract.functions.allowance(
        Web3.to_checksum_address(owner),
        Web3.to_checksum_address(spender),
    ).call()


def test_usdc_allowance_is_zero():
    """USDC allowance to the router must be 0 after revocation."""
    allowance = _get_allowance(USDC_ADDRESS, WALLET, ROUTER)
    assert allowance == 0, f"Expected USDC allowance == 0, got {allowance}"


def test_weth_allowance_is_zero():
    """WETH allowance to the router must be 0 after revocation."""
    allowance = _get_allowance(WETH_ADDRESS, WALLET, ROUTER)
    assert allowance == 0, f"Expected WETH allowance == 0, got {allowance}"
