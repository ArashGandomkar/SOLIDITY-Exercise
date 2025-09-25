// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract mappingB {

    mapping (address => bool) public map;

    function grantAddress(address addr) public {

        map[addr] = true;
    }
    function isAuthorized(address addr) public view returns(bool) {
        return map[addr];
    }
}