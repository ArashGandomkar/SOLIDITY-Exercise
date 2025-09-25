// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract eventC {

    event send(address from, address to, uint balance);
    mapping (address addr=> uint balance) public account;
    address owner;

    constructor() {
        owner = msg.sender;
        account[msg.sender] = 50;
    }
    function sendMoney(address _to,uint value) public returns(bool) {

        require(msg.sender == owner,"You are not allowed.");
        require(account[msg.sender] >= value, "Your balance not enough.");
        account[msg.sender] -= value;
        account[_to] += value;
        
        emit send(owner,_to,value);
        return true;
    }
}