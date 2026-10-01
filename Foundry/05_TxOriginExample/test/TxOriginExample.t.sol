// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {TxOriginExample} from "../src/TxOriginExample.sol";
import {Caller} from "../src/TxOriginExample.sol";

contract TxOriginExampleTest is Test {
    TxOriginExample target;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    function setUp() public {
        target = new TxOriginExample();
    }

    function testDirectCall() public {
        vm.prank(alice, alice);

        (address sender, address origin) =
            target.getAddresses();

        assertEq(sender, alice);
        assertEq(origin, alice);
    }

    function testThroughContract() public {
        Caller caller = new Caller();

        vm.prank(alice, alice);

        (address sender, address origin) =
            caller.callTarget(address(target));

        assertEq(sender, address(caller));
        assertEq(origin, alice);
    }
}