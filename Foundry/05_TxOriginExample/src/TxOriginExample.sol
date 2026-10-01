// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TxOriginExample {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function getAddresses()
        external
        view
        returns (address sender, address origin)
    {
        return (msg.sender, tx.origin);
    }
}

contract Caller {
    function callTarget(address target)
        external view returns (address sender, address origin) {
        return TxOriginExample(target).getAddresses();
    }
}