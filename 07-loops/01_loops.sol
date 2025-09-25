// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract loopsA {

    int8 public a = 0;
    function forloops(int8 i) public returns(int8) {
        
        for(int8 j = 0; j < i; j++) {
            a++;
        }
        return a;
    }
    function whileloops(int8 i) public  returns(int8) {
        int8 j = 0;
        while(j < i) {
            a++;
            j++;
        }
        return  a;
    }
    function dowhileloops(int8 i) public  returns(int8) {
        int8 j = 0;
        do {
            a++;
            j++;
        } while(j < i);
        return  a;
    }
}