"""Tests for defi-concentrated-lp-v3 task."""

import pytest
from web3 import Web3

from libs.constants import DEFAULT_ANVIL_ADDRESS
from libs.web3_utils import get_web3


WALLET = DEFAULT_ANVIL_ADDRESS
POSITION_MANAGER = "0xC36442b4a4522E871399CD717aBDD847Ab11FE88"

# Minimal ERC721 ABI for balanceOf
ERC721_ABI = [
    {
        "inputs": [{"name": "owner", "type": "address"}],
        "name": "balanceOf",
        "outputs": [{"name": "", "type": "uint256"}],
        "stateMutability": "view",
        "type": "function",
    },
]


def test_nft_position_exists():
    """The wallet should hold at least one NFT position after minting."""
    w3 = get_web3()
    pm = w3.eth.contract(
        address=Web3.to_checksum_address(POSITION_MANAGER),
        abi=ERC721_ABI,
    )
    balance = pm.functions.balanceOf(
        Web3.to_checksum_address(WALLET)
    ).call()
    assert balance > 0, f"Expected NFT position balance > 0, got {balance}"
