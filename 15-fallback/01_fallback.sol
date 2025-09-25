// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract fallbackA {

    event log(string name, address to, uint value, bytes data);

    fallback() external payable {

        emit log("Arash", msg.sender, msg.value, msg.data);
    }
    receive() external payable {

        emit log("Ali", msg.sender, msg.value,"");
    }
}