// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract functionB {
    
    uint8 x = 30;
    
    //view
    function add(uint8 y) public view returns(uint8) {
        return  x + y;
    }
    //pure
    function decrease(uint8 a, uint8 b) public pure returns(uint8) {
        return a-b;
    }
}