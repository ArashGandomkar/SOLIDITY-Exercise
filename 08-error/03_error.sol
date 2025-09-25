// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract errorC {
    bool result;
    function testAssert(uint8 num1, uint8 num2) public {
        uint8 sum = num1 + num2;
        assert(sum <= 255);
        result = true;
    }
    function Show() public view returns (string memory) {

        if(result == true) {
            return "No Overflow.";
        }
        else {
            return "Overflow exists.";
        }
    }
    
}