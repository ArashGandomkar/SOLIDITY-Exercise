// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Counter2.sol";

contract Counter2test is Test {
    Counter2 public counter2;

    address owner = address(address(1));
    address user = address(address(2));

    function setUp() public {
        vm.prank(owner);
        counter2 = new Counter2();
    }
    function testIncrementAfterBlock100() public {
        vm.roll(50);
        //vm.expectRevert("Too early");
        counter2.increment();

        vm.roll(102);
        counter2.increment();
        assertEq(counter2.number(), 1);
    }
    function testSetNumberFuzz(uint256 x) public {
        vm.assume(x < type(uint128).max);
        counter2.setNumber(x);
        assertEq(counter2.number(), x);
    }
    function testClearnumberByOwnerTimepass() public {
        vm.startPrank(owner);
        vm.warp(block.timestamp + 1001);
        counter2.clearNumber();
        vm.stopPrank();
        assertEq(counter2.number(), 0);
    }
}