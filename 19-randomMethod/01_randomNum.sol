// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract  randomNum {

    function random(uint max) public view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,msg.sender))) % max;
    }
}