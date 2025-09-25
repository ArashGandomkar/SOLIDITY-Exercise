// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract errorB {

    function oddA(uint8 num) public pure returns(bool) {

        require(num % 2 != 0);
        return true;
    }
    function oddB(uint8 num) public  pure returns(bool) {

        if(num % 2 == 0) {
            revert();
        }
        return true;
    }
}