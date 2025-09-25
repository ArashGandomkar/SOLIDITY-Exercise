// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract errorA {

    function testRequire(uint8 a) public pure {

        require(a > 10, "Input must be greater than 10.");
    }
    function testRevret(uint8 a) public  pure {

        if(a <= 10) {
            revert("Input must be greater than 10.");
        }
    }
}