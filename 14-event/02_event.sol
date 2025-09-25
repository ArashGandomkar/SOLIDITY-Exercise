// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract eventB {

    event Add(address by,uint8 added);
    uint8 []numbers;

    function addNum(uint8 num) public {

        numbers.push(num);
        emit Add(msg.sender, num);
    }
}