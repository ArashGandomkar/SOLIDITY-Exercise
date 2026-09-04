// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Target} from "../src/Target.sol";
import {Caller} from "../src/Caller.sol";

contract DelegatecallTest is Test {

    Target target;
    Caller caller;

    address alice = address(0x1234);

    function setUp() public {
        target = new Target();
        caller = new Caller();

        vm.deal(alice, 10 ether);
    }

    function testCall() public {

        vm.prank(alice);

        caller.executeCall{value: 1 ether}(
            address(target),
            100
        );

        assertEq(target.number(), 100);

        assertEq(target.lastSender(), address(caller));

        assertEq(target.lastThis(), address(target));

        assertEq(
            target.lastValue(),
            1 ether
        );
    }

    function testDelegatecall() public {

        vm.prank(alice);
        caller.executeDelegatecall{value: 2 ether}(address(target), 200);

        assertEq(caller.number(), 200);
        assertEq(target.number(), 0);
        // lastSender == msg.sender
        assertEq(caller.lastSender(), alice);
        // lastThis == address(this)
        assertEq(caller.lastThis(), address(caller));
        // lastValue == msg.value
        assertEq(caller.lastValue(), 2 ether);

    }
}