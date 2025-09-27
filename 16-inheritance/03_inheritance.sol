// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract shape {
    uint8 length = 5;
    uint8 weigth = 3;
    function calcArea() public view virtual returns(uint8) {}
}
contract square is shape {
    function calcArea() public view virtual override  returns(uint8) {
        return length * length;
    }
}
contract rectangle is square {
    function calcArea() public view virtual override  returns(uint8) {
        return length * weigth;
    }
}
contract Super is square,rectangle {
    function calcArea() public view override(rectangle,square)  returns(uint8) {
        return super.calcArea();
    }
}