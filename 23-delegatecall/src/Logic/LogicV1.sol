// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LogicV1 {
    uint256 public number;

    function setNumber(uint256 _number) external {
        number = _number;
    }

    function getNumber() external view returns (uint256) {
        return number;
    }
    
    function willRevert() external pure {
        revert("Something went wrong");
    }

    function version() external pure returns (string memory) {
        return "V1";
    }
}