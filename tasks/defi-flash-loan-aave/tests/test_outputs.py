"""Tests for defi-flash-loan-aave task."""

import json
import subprocess

import pytest
from web3 import Web3

from libs.constants import DEFAULT_ANVIL_ADDRESS, USDC_ADDRESS
from libs.web3_utils import get_web3


WALLET = DEFAULT_ANVIL_ADDRESS
AAVE_POOL = "0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2"
RPC = "http://localhost:8545"

# ABI for our FlashLoanReceiver
FLASH_LOAN_RECEIVER_ABI = [
    {
        "inputs": [],
        "name": "flashLoanExecuted",
        "outputs": [{"name": "", "type": "bool"}],
        "stateMutability": "view",
        "type": "function",
    },
    {
        "inputs": [],
        "name": "lastPremium",
        "outputs": [{"name": "", "type": "uint256"}],
        "stateMutability": "view",
        "type": "function",
    },
]


def _find_deployed_contract() -> str:
    """Find the deployed FlashLoanReceiver by scanning recent transactions.

    We look for contracts deployed by the wallet by checking transaction
    receipts for contractAddress fields.
    """
    w3 = get_web3()
    latest_block = w3.eth.block_number

    # Scan recent blocks for contract creation transactions
    for block_num in range(latest_block, max(latest_block - 50, 0), -1):
        block = w3.eth.get_block(block_num, full_transactions=True)
        for tx in block.transactions:
            if (
                tx["from"].lower() == WALLET.lower()
                and (tx["to"] is None or tx["to"] == "")
            ):
                receipt = w3.eth.get_transaction_receipt(tx["hash"])
                if receipt.get("contractAddress"):
                    return receipt["contractAddress"]

    pytest.fail("Could not find deployed FlashLoanReceiver contract")


def test_flash_loan_executed():
    """The flash loan receiver contract should report that executeOperation was called."""
    receiver_address = _find_deployed_contract()
    w3 = get_web3()

    contract = w3.eth.contract(
        address=Web3.to_checksum_address(receiver_address),
        abi=FLASH_LOAN_RECEIVER_ABI,
    )

    executed = contract.functions.flashLoanExecuted().call()
    assert executed is True, "flashLoanExecuted should be true"


def test_flash_loan_premium_recorded():
    """The flash loan receiver should have recorded a non-zero premium."""
    receiver_address = _find_deployed_contract()
    w3 = get_web3()

    contract = w3.eth.contract(
        address=Web3.to_checksum_address(receiver_address),
        abi=FLASH_LOAN_RECEIVER_ABI,
    )

    premium = contract.functions.lastPremium().call()
    assert premium > 0, f"Expected premium > 0, got {premium}"
