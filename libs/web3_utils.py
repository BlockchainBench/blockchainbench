"""Web3 connection helpers and common contract interactions."""

from web3 import Web3

from libs.constants import ERC20_ABI, TOKEN_DECIMALS, TOKENS


def get_web3(rpc_url: str = "http://localhost:8545") -> Web3:
    """Connect to a local Anvil instance (or other JSON-RPC endpoint)."""
    w3 = Web3(Web3.HTTPProvider(rpc_url))
    if not w3.is_connected():
        raise ConnectionError(f"Failed to connect to {rpc_url}")
    return w3


def get_eth_balance(address: str, rpc_url: str = "http://localhost:8545") -> float:
    """Return ETH balance for an address, denominated in ether."""
    w3 = get_web3(rpc_url)
    balance_wei = w3.eth.get_balance(Web3.to_checksum_address(address))
    return float(Web3.from_wei(balance_wei, "ether"))


def get_erc20_balance(
    token_address: str,
    wallet_address: str,
    rpc_url: str = "http://localhost:8545",
) -> float:
    """Return ERC20 token balance, adjusted for the token's decimals."""
    w3 = get_web3(rpc_url)
    token_address = Web3.to_checksum_address(token_address)
    wallet_address = Web3.to_checksum_address(wallet_address)

    contract = w3.eth.contract(address=token_address, abi=ERC20_ABI)
    raw_balance = contract.functions.balanceOf(wallet_address).call()

    # Look up decimals: use known mapping first, fall back to on-chain call
    decimals = TOKEN_DECIMALS.get(token_address)
    if decimals is None:
        decimals = contract.functions.decimals().call()

    return raw_balance / (10**decimals)


def approve_token(
    web3: Web3,
    token_address: str,
    spender: str,
    amount: int,
    private_key: str,
) -> dict:
    """Approve a spender to spend `amount` (raw units) of an ERC20 token.

    Returns the transaction receipt.
    """
    token_address = Web3.to_checksum_address(token_address)
    spender = Web3.to_checksum_address(spender)

    contract = web3.eth.contract(address=token_address, abi=ERC20_ABI)
    account = web3.eth.account.from_key(private_key)

    tx = contract.functions.approve(spender, amount).build_transaction(
        {
            "from": account.address,
            "nonce": web3.eth.get_transaction_count(account.address),
            "gas": 100_000,
            "gasPrice": web3.eth.gas_price,
        }
    )

    signed = web3.eth.account.sign_transaction(tx, private_key)
    tx_hash = web3.eth.send_raw_transaction(signed.raw_transaction)
    receipt = web3.eth.wait_for_transaction_receipt(tx_hash)
    return dict(receipt)


# Convenience: common token addresses for quick lookup
COMMON_TOKENS = TOKENS
