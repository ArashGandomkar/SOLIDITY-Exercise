// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ifelse {
    bytes word;
    function name (uint8 i) public {
        if(i == 1) {
            word = "ETH";
        }
        else if(i == 2) {
            word = "BTC";
        }
        else word = "BNB";
    }
    function convertor() public view returns(string memory) {
        string memory converted = string(word);
        return converted;
    }
}