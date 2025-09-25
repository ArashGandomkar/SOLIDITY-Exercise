// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract mappingA {

    mapping (address => uint8) public map;

    function set(address addr, uint8 value) public {

        map[addr] = value;
    }
    function get(address addr) public  view returns(uint8) {
        return map[addr];
    }
    function ignore(address addr) public {
        delete map[addr];
    }
}