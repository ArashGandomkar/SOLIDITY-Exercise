// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract loopsC {

    uint8 []array = [1,2,3,4,5];
    function checking(uint8 num) public view returns(bool) {
        bool available;
        for(uint8 i = 0; i < array.length; i++) {
            if(array[i] == num) {
                available = true;
            }
        }
        return  available;
    }
}