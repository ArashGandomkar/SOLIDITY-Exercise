// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//Inheritance

contract A {
    string public name;
    function createName(string memory _name) public {
        name = _name;
    }
}
interface IA {
    function createName(string memory _name) external;
    function name() external  view returns(string memory);
}
contract B {
    function showName(address _contract) public view returns(string memory) {
        return IA(_contract).name();
    }
    function createName(string memory _name,address _contract) public {
        IA(_contract).createName(_name);
    }
}