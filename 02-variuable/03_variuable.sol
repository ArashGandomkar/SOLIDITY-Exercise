// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.0 < 0.9.0;
contract test {
    uint a = 20;
    uint b = 40;
    function getVar() public returns(uint) {
        a = b;
        b = 50;
        return a;
    }
}