// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MaliciousLogic {

    function drain() external {
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {}
}