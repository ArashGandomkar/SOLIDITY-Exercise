// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;

    address owner = address(1);
    address user = address(2);

    function setUp() public {
        vm.prank(owner);
        counter = new Counter();
    }

    function testInitialCountIsZero() public view {
        assertEq(counter.count(), 0);
    }

    function testIncrement() public {
        counter.increment();
        assertEq(counter.count(), 1);
    }

    function testOwnerCanSetCount() public {
        vm.prank(owner);
        counter.setCount(10);
        assertEq(counter.count(), 10);
    }

    function testNonOwnerCannotSetCount() public {
        vm.prank(user);
        vm.expectRevert(bytes("Not owner"));
        counter.setCount(10);
    }
}