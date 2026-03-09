// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
}

interface IPool {
    function flashLoanSimple(
        address receiverAddress,
        address asset,
        uint256 amount,
        bytes calldata params,
        uint16 referralCode
    ) external;
}

/**
 * @title FlashLoanReceiver
 * @notice Minimal flash loan receiver for Aave V3 flashLoanSimple.
 *         Receives USDC, approves repayment, and returns true.
 */
contract FlashLoanReceiver {
    address public immutable POOL;
    bool public flashLoanExecuted;
    uint256 public lastPremium;

    constructor(address pool) {
        POOL = pool;
    }

    /**
     * @notice Called by Aave Pool during flashLoanSimple execution.
     */
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address /* initiator */,
        bytes calldata /* params */
    ) external returns (bool) {
        require(msg.sender == POOL, "Caller must be Pool");

        // Record that the flash loan was executed
        flashLoanExecuted = true;
        lastPremium = premium;

        // Approve the Pool to pull back (amount + premium)
        uint256 repayAmount = amount + premium;
        IERC20(asset).approve(POOL, repayAmount);

        return true;
    }

    /**
     * @notice Initiate a flash loan.
     */
    function requestFlashLoan(address asset, uint256 amount) external {
        IPool(POOL).flashLoanSimple(address(this), asset, amount, "", 0);
    }
}
