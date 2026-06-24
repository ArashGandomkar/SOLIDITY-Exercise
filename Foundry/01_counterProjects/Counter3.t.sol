// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Counter3.sol";

contract Counter3Test is Test {
    Counter3 public counter3;
    address owner = address(1);
    address user = address(2);

    function setUp() public {
        vm.prank(owner);
        counter3 = new Counter3();
    }
    //Call by user
    function testIncrementEmitsEvent() public {
        //vm.expectEmit(checkTopic1, checkTopic2, checkTopic3, checkData);
        vm.expectEmit(true, false, false, true);
        emit Counter3.NumberChanged(0, 1);
        counter3.increment();
        assertEq(counter3.number(), 1);
    }
    //Call by owner
    function testSetNumberEmitsEvent2() public {
        //vm.expectEmit(checkTopic1, checkTopic2, checkTopic3, checkData);
        vm.startPrank(owner);
        vm.expectEmit(true, false, false, true);
        emit Counter3.NumberChanged(0, 1);
        counter3.increment();
        vm.stopPrank();
        assertEq(counter3.number(), 1);
    }
    function testSetNumberEmitsEvent() public {
        vm.prank(owner);
        vm.expectEmit(true, false, false, true);
        emit Counter3.NumberChanged(0, 50);
        counter3.setNumber(50);
        assertEq(counter3.number(), 50);
    }
}