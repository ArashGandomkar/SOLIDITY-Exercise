// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract simpleBank {

    address owner;
    event LogDepositMade(address sender,uint amount);
    constructor() {
        owner = msg.sender;
    }
    mapping(address=>uint) private balances;

    function Deposit() public payable returns(uint) {
        require((balances[msg.sender] + msg.value) >= balances[msg.sender]);

        balances[msg.sender] += msg.value;
        emit LogDepositMade(msg.sender, msg.value);
        return balances[msg.sender];
    }
    function Withdraw(address reciever, uint _amount) public payable returns(uint) {
        require(_amount <= balances[msg.sender], "Insufficient funds...");

        balances[msg.sender] -= _amount;
        payable (reciever).transfer(_amount);
        return balances[msg.sender];
    }
    function Balances() public view returns(uint) {
        return balances[msg.sender];
    }
}