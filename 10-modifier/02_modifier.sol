// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract modifierB {

    address public  owner;
    uint public x = 10;
    bool public  locked;
    constructor() {
        owner = msg.sender;
    }
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner.");
        _;
    }
    modifier validAddress(address test) {
        require(test != address(0), "Not valid address.");
        _;
    }
    function changeOwner(address newOwner) public onlyOwner validAddress(newOwner) {
        owner = newOwner;
    }

    modifier noreetrancy() {
        require(!locked, "No Reetrancy");
        locked = true;
        _;
        locked = false;
    }
    function decrement(uint8 i) public noreetrancy {
        x -= i;
        if(i > 1) {
            decrement(i - 1);
        }
    }
}