// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract A {
    function write() public pure virtual returns(string memory) {
        return "AA";
    }
}
contract B {
    function write() public pure virtual returns(string memory) {
        return "BB";
    }
    function Read() public pure returns(string memory) {
        return "RR";
    }
}
contract C is A,B {
    function write() public pure override (A,B) returns(string memory) {
        return "CC";
    }
}