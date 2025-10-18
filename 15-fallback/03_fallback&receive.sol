// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FallbackMethod {
    event log(string,uint);
    fallback() external payable {
        emit log("Fallback",msg.value);
    }
    receive() external payable {
        emit log("receive",msg.value);
    }
}
contract Fallback_with_input {
    event log(string,uint);
    function makeSum(uint a, uint b) public returns(uint sum) {
        sum = a + b;
        emit log("makeSum",sum);
        return sum;
    }
    fallback(bytes calldata data) external payable returns(bytes memory){
        (bool succsess, bytes memory retdata) = address(this).call(data);
        require(succsess,"Calll failled...");
        return retdata;
    }
    function makeSum_bytes(uint a, uint b) public pure returns(bytes memory) {
        return abi.encodeWithSelector(this.makeSum.selector, a, b);
    }
    receive() external payable { }
}