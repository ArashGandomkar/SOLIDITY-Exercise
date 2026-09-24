// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {LogicV1} from "../src/Logic/LogicV1.sol";
import {LogicV2} from "../src/Logic/LogicV2.sol";
import {MaliciousLogic} from "../src/Logic/MaliciousLogic.sol";
import {SimpleEIP1967Proxy} from "../src/Logic/SimpleEIP1967Proxy.sol";

contract EIP1967Test is Test {

    LogicV1 logic;
    LogicV2 logicV2;
    MaliciousLogic maliciousLogic;
    SimpleEIP1967Proxy proxy;
    address attacker = address(0x1234);
    bytes32 constant IMPLEMENTATION_SLOT =
    0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
    function setUp() public {
        logic = new LogicV1();
        logicV2 = new LogicV2();
        maliciousLogic = new MaliciousLogic();
        proxy = new SimpleEIP1967Proxy(address(logic));
    }

    function testDelegatecall() public {
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
    }

    function testStorageAfterDelegatecall() public {
        // setNumber(100) through proxy
        (bool success, ) = address(proxy).call(
            abi.encodeWithSignature(
                "setNumber(uint256)",
                100
            )
        );
    
        assertTrue(success);
    
        // Read slot 0 of Proxy
        bytes32 value = vm.load(
            address(proxy),
            bytes32(uint256(0))
        );
    
        // Convert bytes32 to uint256
        uint256 storedValue = uint256(value);
    
        assertEq(storedValue, 100);
    }

    function testImplementationStorageSlot() public view {
        bytes32 raw = vm.load(address(proxy), IMPLEMENTATION_SLOT);
        address storedImplementation = address(uint160(uint256(raw)));

        assertEq(address(logic), storedImplementation);
    }

    function testReturnData() public {
        (bool success,) = address(proxy).call(
            abi.encodeWithSignature("setNumber(uint256)", 100));
        assertTrue(success);

        (bool readSuccess, bytes memory data) = address(proxy).call(
            abi.encodeWithSignature("getNumber()"));
        assertTrue(readSuccess);

        uint256 value = abi.decode(data, (uint256));
        assertEq(value, 100);
    }

    function testRevertForwarding() public  {
        (bool success, bytes memory data) = address(proxy).call(
            abi.encodeWithSignature("willRevert()"));
        assertFalse(success);
        assertTrue(data.length > 0);
    }

    function testUpgrade() public {
        assertEq(
            proxy.implementation(),
            address(logic)
        );

        proxy.upgradeTo(address(logicV2));

        assertEq(
            proxy.implementation(),
            address(logicV2)
        );
    }

    function testUpgradePreservesStorage() public {
        (bool success,) = address(proxy).call(
            abi.encodeWithSignature("setNumber(uint256)", 100));
        assertTrue(success);

        (bool readSuccess, bytes memory data) = address(proxy).call(
            abi.encodeWithSignature("getNumber()"));
        assertTrue(readSuccess);
        uint256 beforeUpgrade = abi.decode(data, (uint256));
        assertEq(beforeUpgrade, 100);

        proxy.upgradeTo(address(logicV2));

        assertEq(proxy.implementation(),address(logicV2));

        (success,) = address(proxy).call(
            abi.encodeWithSignature("increment()"));
        assertTrue(success);
        
        (, data) = address(proxy).call(
            abi.encodeWithSignature("getNumber()"));
        uint256 afterUpgrade = abi.decode(data, (uint256));
        assertEq(afterUpgrade, 101);
        assertGe(afterUpgrade, beforeUpgrade);
    }

    function testUnprotectedUpgradeAttack() public {

        vm.deal(address(proxy), 10 ether);
        assertEq(address(proxy).balance, 10 ether);

        vm.prank(attacker);
        proxy.upgradeTo(address(maliciousLogic));
        assertEq(
            proxy.implementation(),
            address(maliciousLogic)
        );

        vm.prank(attacker);
        (bool success, ) = address(proxy).call(
            abi.encodeWithSignature("drain()")
        );
        assertTrue(success);
        assertEq(address(proxy).balance, 0);
        assertEq(attacker.balance, 10 ether);
    }
}