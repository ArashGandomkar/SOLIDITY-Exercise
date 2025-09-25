// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract paussedContract {

    address public owner;
    bool public isPaused;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender,"Only owner can execute this.");
        _;
    }
    function sendMoney() public payable {}
    function setPaused(bool input) public onlyOwner{
        isPaused = input;
    } 
    function getBalance() public view onlyOwner returns(uint) {
        return address(this).balance;
    }
    function withdraw(address payable recipient) public onlyOwner {
        require(isPaused == false, "SmartContract is paused.");
        require(address(this).balance > 0, "Address doesn't have Ether.");
        payable(recipient).transfer(address(this).balance);
    }
}