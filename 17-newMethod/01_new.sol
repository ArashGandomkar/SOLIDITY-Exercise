// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract Child {

    uint8 public id;
    uint public balance;

    constructor(uint8 _id) payable {
        id = _id;
        balance = msg.value;
    }
}
contract main {

    Child [] public register;
    function create(uint8 _id) public returns(Child) {

        Child newChild = new Child(_id);
        register.push(newChild);
        return(newChild);
    }
    function createAndPay(uint8 _id) public payable  {

        Child newChild = new Child{value : msg.value}(_id);
        register.push(newChild);
    }
}