// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

//ABI encodeWithSelector
//ABI encodecall

contract A {
    uint public sum;
    function makeSum(uint num1, uint num2) public returns(uint) {
        sum = num1 + num2;
        return sum;
    }
}
interface IA {
    function makeSum(uint num1, uint num2) external returns(uint);
}
contract B {
    function doTheSum(address _contractA, uint num1, uint num2) public returns(bytes memory) {

        (bool success, bytes memory data) = _contractA.call(abi.encodeWithSelector(IA.makeSum.selector, num1, num2));
        require(success,"Call Failled...");
        return data;
    }
    function doTheSum2(address _contractA, uint num1, uint num2) public returns(bytes memory) {
        A contractNewA = new A();
        (bool success, bytes memory data) = _contractA.call(abi.encodeWithSelector(contractNewA.makeSum.selector, num1, num2));
        require(success,"Call Failled...");
        return data;
    }
    function doTheSum3(address _contractA, uint num1, uint num2) public returns(bytes memory) {
        (bool success, bytes memory data) = _contractA.call(abi.encodeCall(IA.makeSum, (num1, num2)));
        require(success, "Call Failled...");
        return data;
    }
}