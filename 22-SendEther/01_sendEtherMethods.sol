// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract sendingEther {
    function sendViaTransfer(address payable _to) public payable {
        (_to).transfer(msg.value);
    }
    function sendViaSend(address payable _to) public payable {
        bool success = (_to).send(msg.value);
        require(success, "Sending failled...");
    }
    function sendViaCall(address payable _to) public payable {
        (bool success, bytes memory data) = (_to).call{value: msg.value}("");
        require(success, "Sending failled...");
    }
}