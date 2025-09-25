// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.0 < 0.9.0;
contract LerarnVariuable {
    uint8 a = 255;
    uint16 b = 2000;
    uint16 c = a + b;
    address owner = 0xc3eAB3868440DecCD56bb6b7b44D4594C41167bd;
    address costumer;
    function setAddress(address x) public {
        costumer = x;
    }
    function getAddress() public view returns (address) {
        return costumer;
    }
}