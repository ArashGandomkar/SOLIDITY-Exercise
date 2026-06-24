// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Counter3 {
    uint256 public number;
    address owner;
    event NumberChanged(uint256 indexed oldNumber, uint256 newNumber);

    constructor() {
        owner = msg.sender;
    }
    function setNumber(uint256 x) public {
        require(owner == msg.sender, "Not owner");
        uint256 oldNumber = number;
        number = x;
        emit NumberChanged(oldNumber, x);
    }
    function increment() public {
        require(owner == msg.sender, "Not owner");
        uint256 oldNumber = number;
        number++;
        emit NumberChanged(oldNumber, number);
    }
}