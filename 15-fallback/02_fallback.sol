// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract fallbackB1 {

    event log(uint amount, uint gas);

    fallback() external payable {

        emit log(msg.value, gasleft());
    }
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
}
contract sendEther {

    function sendviaTransfer(address payable to) public payable {

        to.transfer(msg.value);
    }
    function sendviaCall(address payable to) public payable {

        (bool sent, ) = to.call{value: msg.value}("");
        require(sent, "Faild to send Ehter.");
    }
}