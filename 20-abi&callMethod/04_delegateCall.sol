// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {
    uint public sum;
    uint public number;
    address public sender;
    function test(uint a,uint b) public returns(uint) {
        sum = a + b;
        number = a;
        sender = msg.sender;
        return sum;
    }
}
contract B {
    uint public newSum;
    uint public newNumber;
    address public newSender;
    function doIt(address _contractA,uint a, uint b) public returns(uint) {
        (bool success, bytes  memory data) = _contractA.delegatecall(abi.encodeWithSignature("test(uint256,uint256)", a, b));
        require(success,"Call failed...");
        return abi.decode(data, (uint));
    }
}