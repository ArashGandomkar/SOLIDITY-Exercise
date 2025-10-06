// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {
    uint public sum;
    function makeSum(uint a, uint b) public returns(uint) {
        sum = a + b;
        return sum;
    }
    function makeSum2(uint a, uint b) public pure returns(uint sum2) {
        sum2 = a + b;
    }
}
contract B {
    function doTheSum(address _contractA,uint a, uint b) public view returns(uint) {
        (bool success, bytes memory data) = _contractA.staticcall(abi.encodeWithSignature("makeSum2(uint256,uint256)", a, b));
        require(success,"Call failed.");
        return abi.decode(data, (uint));
    }
}