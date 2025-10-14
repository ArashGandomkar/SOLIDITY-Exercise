// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract A is Ownable{
    constructor() Ownable(msg.sender) {}
    uint public number;
    function updateNum(uint num) public onlyOwner returns(uint) {
        number = num;
        return number;
    }
}