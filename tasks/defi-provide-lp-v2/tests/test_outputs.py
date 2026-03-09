"""Tests for defi-provide-lp-v2 task."""

import pytest
from web3 import Web3

from libs.constants import (
    DEFAULT_ANVIL_ADDRESS,
    ERC20_ABI,
    USDC_ADDRESS,
    WETH_ADDRESS,
)
from libs.web3_utils import get_web3


WALLET = DEFAULT_ANVIL_ADDRESS
UNISWAP_V2_FACTORY = "0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f"

FACTORY_ABI = [
    {
        "inputs": [
            {"name": "tokenA", "type": "address"},
            {"name": "tokenB", "type": "address"},
        ],
        "name": "getPair",
        "outputs": [{"name": "pair", "type": "address"}],
        "stateMutability": "view",
        "type": "function",
    },
]


def _get_pair_address() -> str:
    """Look up the USDC/WETH pair address from the Uniswap V2 Factory."""
    w3 = get_web3()
    factory = w3.eth.contract(
        address=Web3.to_checksum_address(UNISWAP_V2_FACTORY),
        abi=FACTORY_ABI,
    )
    pair = factory.functions.getPair(
        Web3.to_checksum_address(USDC_ADDRESS),
        Web3.to_checksum_address(WETH_ADDRESS),
    ).call()
    return pair


def test_lp_token_balance_greater_than_zero():
    """After providing liquidity, the wallet should hold LP tokens."""
    pair_address = _get_pair_address()
    assert pair_address != "0x" + "0" * 40, "Pair does not exist"

    w3 = get_web3()
    pair = w3.eth.contract(
        address=Web3.to_checksum_address(pair_address),
        abi=ERC20_ABI,
    )
    lp_balance = pair.functions.balanceOf(
        Web3.to_checksum_address(WALLET)
    ).call()
    assert lp_balance > 0, f"Expected LP token balance > 0, got {lp_balance}"
