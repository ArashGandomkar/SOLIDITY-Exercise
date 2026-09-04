// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Target {
    uint256 public number;

    address public lastSender;

    address public lastThis;

    uint256 public lastValue;

    function setNumber(uint256 _number) external payable {
        number = _number;
        lastSender = msg.sender;
        lastThis = address(this);
        lastValue = msg.value;
    }
}