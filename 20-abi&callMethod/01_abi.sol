// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//Abi

contract test {
    function encodeIt(uint a, uint b) public pure returns(bytes memory) {
        return abi.encode(a, b);
    }
    function encodeIt1(uint a, uint b) public pure returns(bytes memory) {
        return abi.encodePacked(a, b);
    }
    function decodeIt(bytes memory data) public pure returns(uint , uint ) {
        return abi.decode(data, (uint, uint));
    }

}