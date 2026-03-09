"""Wallet utilities for funding and managing test accounts."""

from web3 import Web3

from libs.constants import DEFAULT_ANVIL_ADDRESS, DEFAULT_ANVIL_PRIVATE_KEY
from libs.web3_utils import get_web3


def load_wallet(
    rpc_url: str = "http://localhost:8545",
) -> tuple[Web3, "LocalAccount"]:  # noqa: F821
    """Load the default Anvil wallet.

    Returns a (web3, account) tuple where account is an eth_account
    LocalAccount derived from the default Anvil private key.
    """
    w3 = get_web3(rpc_url)
    account = w3.eth.account.from_key(DEFAULT_ANVIL_PRIVATE_KEY)

    # Sanity check: the derived address should match the known default
    assert account.address.lower() == DEFAULT_ANVIL_ADDRESS.lower(), (
        f"Derived address {account.address} does not match "
        f"expected {DEFAULT_ANVIL_ADDRESS}"
    )

    return w3, account


def sign_and_send(web3: Web3, tx: dict, private_key: str) -> dict:
    """Build, sign, send a transaction, and wait for the receipt.

    Args:
        web3: Connected Web3 instance.
        tx: Transaction dict (must include 'to', 'from', etc.).
            If 'nonce' is missing it will be filled automatically.
            If 'gas' is missing it will be estimated.
            If 'gasPrice' is missing the current gas price is used.
        private_key: Hex-encoded private key for signing.

    Returns:
        Transaction receipt as a dict.
    """
    account = web3.eth.account.from_key(private_key)

    # Fill in optional fields
    if "nonce" not in tx:
        tx["nonce"] = web3.eth.get_transaction_count(account.address)
    if "gasPrice" not in tx:
        tx["gasPrice"] = web3.eth.gas_price
    if "gas" not in tx:
        tx["gas"] = web3.eth.estimate_gas(tx)
    if "chainId" not in tx:
        tx["chainId"] = web3.eth.chain_id

    signed = web3.eth.account.sign_transaction(tx, private_key)
    tx_hash = web3.eth.send_raw_transaction(signed.raw_transaction)
    receipt = web3.eth.wait_for_transaction_receipt(tx_hash)
    return dict(receipt)
