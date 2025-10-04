// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//Call

contract A {
    uint public sum;
    function makeSum(uint a, uint b) public returns(uint) {
        sum = a + b;
        return sum;
    }
}
contract B {
    function makeSum(address _contractA,uint a, uint b) public returns(bytes memory) {
        (bool success,bytes memory data) = _contractA.call(abi.encodeWithSignature("makeSum(uint256,uint256)", a,b));
        require(success,"Call failed");
        return data;
    }
}