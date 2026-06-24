// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Vault {
    mapping(address => uint256) public balances;
    uint256 public totalDeposited;

    function Deposit() external payable {
        require(msg.value > 0, "No ether");
        balances[msg.sender] += msg.value;
        totalDeposited += msg.value;
    }
    function Withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        totalDeposited -= amount;
        payable(msg.sender).transfer(amount);
    }
}