// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract arrays {

    bytes sentence = "Hello, World";
    string public word;
    function convertor() public view returns(string memory) {
        string memory converted = string(sentence);
        return converted;
    }
    function setter() public {
        word = "Arash";
    }
}