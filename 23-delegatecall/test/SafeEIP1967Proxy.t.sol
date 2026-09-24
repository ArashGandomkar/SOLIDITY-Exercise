// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {LogicV1} from "../src/Logic/LogicV1.sol";
import {LogicV2} from "../src/Logic/LogicV2.sol";
import {SafeEIP1967Proxy} from "../src/Logic/SafeEIP1967Proxy.sol";

contract SafeEIP1967ProxyTest is Test {

    LogicV1 logicV1;
    LogicV2 logicV2;
    SafeEIP1967Proxy proxy;

    address attacker = address(0x1234);

    function setUp() public {
        logicV1 = new LogicV1();
        logicV2 = new LogicV2();

        proxy = new SafeEIP1967Proxy(
            address(logicV1)
        );
    }

    function testAdmin() public {
        assertEq(
            proxy.admin(),
            address(this)
        );
    }

    function testUpgrade() public {
        proxy.upgradeTo(address(logicV2));

        assertEq(
            proxy.implementation(),
            address(logicV2)
        );
    }

    function testNonAdminCannotUpgrade() public {
        vm.prank(attacker);

        vm.expectRevert("NOT_ADMIN");

        proxy.upgradeTo(
            address(logicV2)
        );
    }

    function testStorageStillWorksAfterDelegatecall() public {
        (bool success, ) = address(proxy).call(
            abi.encodeWithSignature(
                "setNumber(uint256)",
                100
            )
        );
    
        assertTrue(success);
    
        (bool readSuccess, bytes memory data) =
            address(proxy).staticcall(
                abi.encodeWithSignature("number()")
            );
    
        assertTrue(readSuccess);
    
        uint256 value = abi.decode(
            data,
            (uint256)
        );
    
        assertEq(value, 100);
    
        assertEq(
            proxy.admin(),
            address(this)
        );
    }
}