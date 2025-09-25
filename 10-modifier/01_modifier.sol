// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract modifierA {

    modifier fee(uint _fee) {

        if(_fee != msg.value) {
            revert("You must pay  a gas to withdraw your Ehters.");
        }
        else {
            _;
        }
    }
    function Deposit(address user, uint amount) external {}
    function Withdraw(uint amount) external payable fee(0.025 ether) {}
}