// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LogicV2 {
    uint256 public number;

    function setNumber(uint256 _number) external {
        number = _number;
    }

    function increment() external {
        number += 1;
    }

    function getNumber() external view returns (uint256) {
        return number;
    }

    function version() external pure returns (string memory) {
        return "V2";
    }
}