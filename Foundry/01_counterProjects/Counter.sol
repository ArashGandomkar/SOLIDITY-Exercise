// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Counter {
    uint256 public count;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function increment() public {
        count += 1;
    }

    function setCount(uint256 _count) public {
        require(msg.sender == owner, "Not owner");
        count = _count;
    }
}