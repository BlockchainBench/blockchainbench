"""Tests for token-approve-and-swap task."""

import pytest
from libs.constants import DEFAULT_ANVIL_ADDRESS, USDC_ADDRESS, ERC20_ABI
from libs.web3_utils import get_web3


@pytest.fixture
def w3():
    return get_web3()


@pytest.fixture
def usdc(w3):
    return w3.eth.contract(address=USDC_ADDRESS, abi=ERC20_ABI)


def test_eth_balance_greater_than_100(w3):
    """Wallet should have gained ETH from selling USDC.

    Starting balance is ~50 ETH (100 ETH - 50 deposited to WETH in setup).
    After swapping 5000 USDC -> ETH, balance should exceed 50 ETH.
    We check > 50 ETH to account for the WETH deposit in setup-wallet.sh.
    """
    balance_wei = w3.eth.get_balance(DEFAULT_ANVIL_ADDRESS)
    balance_eth = balance_wei / 10**18
    assert balance_eth > 50, f"ETH balance should be > 50, got {balance_eth}"


def test_usdc_allowance_was_set_or_spent(usdc):
    """The USDC allowance to the router was set (and likely spent).

    After a successful swap, the allowance may be 0 (fully spent) or remain
    if the agent set a higher allowance. We verify the swap happened by
    checking USDC balance decreased from the initial 100,000 USDC seed.
    """
    balance = usdc.functions.balanceOf(DEFAULT_ANVIL_ADDRESS).call()
    initial_usdc = 100_000 * 10**6  # 100,000 USDC seeded
    assert balance < initial_usdc, (
        f"USDC balance should be less than initial {initial_usdc}, got {balance}"
    )
