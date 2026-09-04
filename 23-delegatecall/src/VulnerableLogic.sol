// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VulnerableLogic {

    uint256 public number;
    function setNumber(uint256 _number) external {
        number = _number;
    }
}