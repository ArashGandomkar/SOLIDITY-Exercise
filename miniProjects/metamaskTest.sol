// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract metamaskTest {

    event Log(address from, uint amount,address to);

    function sendEther(address _to) public payable {

        emit Log(msg.sender,msg.value,_to);
    }
}