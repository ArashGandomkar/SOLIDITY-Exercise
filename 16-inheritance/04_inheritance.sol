// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract base {
    uint8 public number;
    constructor(uint8 _number) {
        number = _number;
    }
}
contract test1 is base(10) {}
contract base2 {
    string public name;
    constructor(string memory _name) {
        name = _name;
    }
}
contract test2 is base(14), base2 {
    constructor() base2("Arash") {}
}