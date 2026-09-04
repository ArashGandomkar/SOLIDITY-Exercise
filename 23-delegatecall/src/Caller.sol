// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Caller {

    uint256 public number;

    address public lastSender;

    address public lastThis;

    uint256 public lastValue;

    function executeCall(
        address target,
        uint256 value
    ) external payable {

        target.call{value: msg.value}(
            abi.encodeWithSignature(
                "setNumber(uint256)",
                value
            )
        );
    }

    function executeDelegatecall(
        address target,
        uint256 value
    ) external payable {
        (bool success, ) = target.delegatecall(
            abi.encodeWithSignature(
                "setNumber(uint256)",
                value
            )
        );

        require(success, "DELEGATECALL_FAILED");
    }
}