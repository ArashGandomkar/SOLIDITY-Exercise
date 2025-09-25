// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract functionC {

    uint8 a = 10;
    uint8 b = 15;
    
    function avg() private view returns (uint8) {
        return (a + b) / 2;
    }
    function show() public  view returns (uint8) {
        return avg();
    }
    function test() private pure  returns (uint8) {
        uint8 d = 25;
        return d;
    }
    function Test() public  pure returns (uint8) {
        return Test();
    }
}