"""Tests for defi-supply-aave-v3 task."""

import pytest
from libs.constants import DEFAULT_ANVIL_ADDRESS, ERC20_ABI
from libs.web3_utils import get_web3

AUSDC_ADDRESS = "0x98C23E9d8f34FEFb1B7BD6a91B7FF122F4e16F5c"


@pytest.fixture
def w3():
    return get_web3()


@pytest.fixture
def ausdc(w3):
    return w3.eth.contract(
        address=w3.to_checksum_address(AUSDC_ADDRESS), abi=ERC20_ABI
    )


def test_ausdc_balance_greater_than_zero(ausdc):
    """Wallet should hold aUSDC after supplying USDC to Aave V3."""
    balance = ausdc.functions.balanceOf(DEFAULT_ANVIL_ADDRESS).call()
    assert balance > 0, f"aUSDC balance should be > 0, got {balance}"
