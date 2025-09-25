// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract arraysB {

    uint8 [] public array1;
    uint8 [] public array2 = [10,20,30,40,50];
    uint8 [] myfixedarray;

    function push(uint8 i) public {
        array2.push(i);
    }
    function get(uint index) public view returns(uint8) {
        return array2[index];
    }
    function changeindex(uint8 num) public {
        array2[num] = 200;
    }
    function remove(uint8 num) public {
        delete array2[num];
    }
    function pop() public {
        array2.pop();
    }
    function getlength() public view returns(uint) {
        return array2.length;
    }

    //Create Array in Memory
    function createarray() external pure returns(uint[] memory) {
        uint[] memory array = new uint[] (5);
        array[1] = 7;
        return array;
    }
}