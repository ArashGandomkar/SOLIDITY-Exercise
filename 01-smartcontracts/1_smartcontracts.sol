// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.2 < 0.9.0;
contract Practice1 {
    uint16 Data;
    function set(uint8 x, uint8 y) public {
        uint8 temp = x + y;
        Data = temp;
    }
    function get() public view returns(uint) {
        return  Data;
    }
}