// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.0 < 0.9.0;
contract GlobalVariuable {
    uint public mytime;
    address public sender;
    function Set() public {
        mytime = block.timestamp;
        sender = msg.sender;
    }
}