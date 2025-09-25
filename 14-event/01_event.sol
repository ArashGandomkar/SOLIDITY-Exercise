// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract eventA {

    event log(string msg);
    function triggerlog() public {

        emit log("Hello");
    }
}