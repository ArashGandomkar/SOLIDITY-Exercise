// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Drop {
    function dropNum(uint[] storage array, uint index) public {
        for(uint i = index; i < array.length - 1;i++) {
            array[i] = array[i + 1];
        }
        array.pop();
    }
}
contract A {
    using Drop for uint[];
    uint[] public array;
    function addNumbers(uint lengh) public {
        for(uint i = 0; i < lengh; i++) {
            array.push(i+1);
        }
    }
    function removeNumber(uint index) public {
        array.dropNum(index);
    }
}