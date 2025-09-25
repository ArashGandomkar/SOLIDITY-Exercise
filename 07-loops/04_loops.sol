// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract loopsD {

    uint [] array;

    function data(uint num) public returns(uint[] memory) {
        
        for(uint i = 1; i <= num; i++) {
            array.push(i);
        }
    return array;
    }
    function even() public view returns(uint[] memory) {

        uint [] memory evenarray;
        for(uint i = 0; i < array.length; i++) {
            if((array[i] % 2) == 0) {
                evenarray.push(array[i]);
            }
        }
        return evenarray;
    }
    
}