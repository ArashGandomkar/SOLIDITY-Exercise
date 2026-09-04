// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VulnerableProxy {

    address public owner;
    uint256 public number;

    constructor() {
        owner = msg.sender;
    }

    function execute(uint256 value, address target) public {
        
        (bool success, ) = target.delegatecall(
            abi.encodeWithSignature(
                "setNumber(uint256)", value
            )
        );
        require(success, "DELEGATECALL_FAILED");
    }

    function withdraw() external {
        require(msg.sender == owner, "NOT_OWNER");

        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {}
}