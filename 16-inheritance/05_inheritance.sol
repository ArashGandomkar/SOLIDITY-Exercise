// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//Variable Overriding

contract base {
    uint8 public number = 10;
    function showNumber() public  view returns(uint8) {
        return number;
    }
}
contract test is base {
    constructor(uint8 num) {
        number = num;
    }
}