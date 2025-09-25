// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract testConstructor {

    uint8 public  x;
    address public owner;
    uint public time;
    constructor(uint8 num) {

        x = num;
        owner = msg.sender;
        time = block.timestamp;
    }
}