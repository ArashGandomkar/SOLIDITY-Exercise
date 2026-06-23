// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Counter2 {
    uint256 public number;
    address public owner;
    uint256 time;

    constructor() {
        owner = msg.sender;
        time = block.timestamp + 1000;
    }
    function increment() public {
        require(block.number > 100, "Too early");
        number++;
    }
    function setNumber(uint256 x) public {
        number = x;
    }
    function clearNumber() public {
        require(owner == msg.sender, "Not owner");
        require(block.timestamp > time, "Too early");
        number = 0;
    }
}