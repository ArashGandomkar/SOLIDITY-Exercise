// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract operators {

    int8 a = 5;
    int8 b = 3;
    int8 c = 10;
    function calculate() public view returns(int8 result) {
        result = a+b*c;
    }
    function calculate1() private pure returns(int8 test) {
        test = 1;
        test *= 5;
    }
    function calculate2() public pure returns (int8 test) {
        return calculate1();
    }
}