
 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {
    VulnerableDistributor,
    PullPaymentDistributor,
    MaliciousReceiver
} from "../src/DoSDistributor.sol";

contract DoSDistributorTest is Test {
    VulnerableDistributor distributor;
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    MaliciousReceiver attacker;

    function setUp() public {
        attacker = new MaliciousReceiver();
        address[] memory users = new address[](3);
        users[0] = alice;
        users[1] = address(attacker);
        users[2] = bob;

        distributor = new VulnerableDistributor{value: 3 ether}(users);
        vm.deal(address(distributor), 3 ether);
    }

    function test_MaliciousReceiverBlocksAllPayments() public {
        uint256 aliceBefore = alice.balance;
        uint256 bobBefore = bob.balance;
        vm.expectRevert();
        distributor.distribute();

        assertEq(alice.balance, aliceBefore);
        assertEq(bob.balance, bobBefore);
        assertEq(address(distributor).balance, 3 ether);
    }


    function test_PullPaymentIsolatesFailedReceiver() public {
        address[] memory users = new address[](3);
        users[0] = alice;
        users[1] = address(attacker);
        users[2] = bob;

        PullPaymentDistributor pull =
            new PullPaymentDistributor{value: 3 ether}(users);

        vm.expectRevert(bytes("Payment failed"));
        vm.prank(address(attacker));
        pull.claim();
        assertEq(pull.rewards(address(attacker)), 1 ether);

        uint256 aliceBefore = alice.balance;
        vm.prank(alice);
        pull.claim();

        assertEq(alice.balance, aliceBefore + 1 ether);
        assertEq(pull.rewards(alice), 0);

        uint256 bobBefore = bob.balance;
        vm.prank(bob);
        pull.claim();

        assertEq(bob.balance, bobBefore + 1 ether);
        assertEq(pull.rewards(bob), 0);
    }
}