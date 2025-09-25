// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract Fruit {

    uint8 public price;
    string public color;
    uint8 private size = 8;
    string internal country = "Made in Iran.";
    function setColor(string memory _color) public virtual returns(string memory) {

        color = _color;
        return color;
    }
}
contract Apple is Fruit {

    function setColor(string memory _color) public override  returns(string memory) {

        color = _color;
        return color;
    } 
}