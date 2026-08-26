// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {SignatureExecutor} from "../src/SignatureExecutor.sol";

contract SignatureExecutorTest is Test {
    SignatureExecutor executor;
    SignatureExecutor executor2;

    uint256 ownerPrivateKey = 0xA11CE;
    uint256 attackerPrivateKey = 0xB0B;
    address owner;
    address attacker;
    address bob = makeAddr("bob");
    address charlie = makeAddr("charlie");

    function setUp() public {

        owner = vm.addr(ownerPrivateKey);
        attacker = vm.addr(attackerPrivateKey);
        vm.prank(owner);
        executor = new SignatureExecutor();
        vm.prank(owner);
        executor2 = new SignatureExecutor();
        vm.deal(address(executor), 100 ether);
        vm.deal(address(executor2), 100 ether);
    }

    function _signExecute(
        uint256 privateKey,
        address to,
        uint256 amount,
        uint256 nonce,
        uint256 deadline
    ) internal view returns (bytes memory signature) {
        bytes32 digest = executor.getDigest(
            to,
            amount,
            nonce,
            deadline
        );
        (uint8 v, bytes32 r, bytes32 s) =
            vm.sign(privateKey, digest);

        signature = abi.encodePacked(r, s, v);
    }

    function test_ExecuteWithValidSignature() public {

        uint256 amount = 1 ether;
        uint256 nonce = executor.nonces(owner);
        uint256 deadline = block.timestamp + 1 hours;

        bytes memory signature = _signExecute(ownerPrivateKey, bob, amount, nonce, deadline);
        uint256 bobBalanceBefore = bob.balance;

        vm.prank(charlie);
        executor.execute(bob, amount, nonce, deadline, signature);

        assertEq(bob.balance, bobBalanceBefore + amount);
        assertEq(executor.nonces(owner), nonce + 1);
        assertEq(charlie.balance, 0);
    }
    function test_ExecuteWithInValidSignature() public {

        uint256 amount = 1 ether;
        uint256 nonce = executor.nonces(owner);
        uint256 deadline = block.timestamp + 1 hours;

        bytes memory signature = _signExecute(ownerPrivateKey, charlie, amount, nonce, deadline);
        vm.prank(charlie);
        vm.expectRevert();
        executor.execute(bob, amount, nonce, deadline, signature);
    }
    function test_ExecuteWithInValidSignatureDeadline() public {

        uint256 amount = 1 ether;
        uint256 nonce = executor.nonces(owner);
        uint256 deadline = block.timestamp + 1 hours;

        bytes memory signature = _signExecute(ownerPrivateKey, bob, amount, nonce, deadline);
        vm.warp(block.timestamp + 2 hours);
        vm.prank(charlie);
        vm.expectRevert(SignatureExecutor.SignatureExpired.selector);
        executor.execute(bob, amount, nonce, deadline, signature);
    }

    function test_FuzzingExecuteSignature(uint amount) public {

        amount = bound(amount, 1 wei, 100 ether);
        uint256 nonce = executor.nonces(owner);
        uint256 deadline = block.timestamp + 1 hours;

        bytes memory signature = _signExecute(ownerPrivateKey, bob, amount, nonce, deadline);
        uint256 bobBalanceBefore = bob.balance;

        vm.prank(charlie);
        executor.execute(bob, amount, nonce, deadline, signature);

        assertEq(bob.balance, bobBalanceBefore + amount);
        assertEq(executor.nonces(owner), nonce + 1);
    }

    function test_RevertIfInvalidSigner() public {

        uint256 amount = 1 ether;
        uint256 nonce = executor.nonces(owner);
        uint256 deadline = block.timestamp + 1 hours;

        bytes memory signature = _signExecute(
            attackerPrivateKey,
            bob,
            amount,
            nonce,
            deadline
        );
        vm.expectRevert(SignatureExecutor.InvalidSigner.selector);

        executor.execute(
            bob,
            amount,
            nonce,
            deadline,
            signature
        );
    }

    function test_ReplayFails() public {

        uint256 amount = 1 ether;
        uint256 nonce = executor.nonces(owner);
        uint256 deadline = block.timestamp + 1 hours;

        bytes memory signature = _signExecute(
            ownerPrivateKey,
            bob,
            amount,
            nonce,
            deadline
        );

        // First execution
        executor.execute(
            bob,
            amount,
            nonce,
            deadline,
            signature
        );
        assertEq(executor.nonces(owner), nonce + 1);

        // Replay
        vm.expectRevert(SignatureExecutor.InvalidNonce.selector);
        executor.execute(
            bob,
            amount,
            nonce,
            deadline,
            signature
        );
    }

    function test_RevertIfWrongNonce() public {

        uint256 amount = 1 ether;
        uint256 wrongNonce = 1;
        uint256 deadline = block.timestamp + 1 hours;

        bytes memory signature = _signExecute(
            ownerPrivateKey,
            bob,
            amount,
            wrongNonce,
            deadline
        );

        vm.expectRevert(SignatureExecutor.InvalidNonce.selector);
        executor.execute(
            bob,
            amount,
            wrongNonce,
            deadline,
            signature
        );
    }

    function test_CannotChangeAmount() public {

        uint256 signedAmount = 1 ether;
        uint256 manipulatedAmount = 100 ether;
        uint256 nonce = executor.nonces(owner);
        uint256 deadline = block.timestamp + 1 hours;
    
        bytes memory signature = _signExecute(
            ownerPrivateKey,
            bob,
            signedAmount,
            nonce,
            deadline
        );
    
        vm.expectRevert(SignatureExecutor.InvalidSigner.selector);
        executor.execute(
            bob,
            manipulatedAmount,
            nonce,
            deadline,
            signature
        );
    }

    function test_CannotChangeRecipient() public {

        uint256 amount = 1 ether;
        uint256 nonce = executor.nonces(owner);
        uint256 deadline = block.timestamp + 1 hours;

        bytes memory signature = _signExecute(
            ownerPrivateKey,
            bob,
            amount,
            nonce,
            deadline
        );

        vm.expectRevert(SignatureExecutor.InvalidSigner.selector);
        executor.execute(
            attacker,
            amount,
            nonce,
            deadline,
            signature
        );
    }

    function test_CannotReplayAcrossContracts() public {
        uint256 amount = 1 ether;
        uint256 nonce = executor.nonces(owner);
        uint256 deadline = block.timestamp + 1 hours;

        bytes memory signature = _signExecute(
            ownerPrivateKey,
            bob,
            amount,
            nonce,
            deadline
        );
        
        bytes32 digestA = executor.getDigest(bob, amount, nonce, deadline);
        bytes32 digestB = executor2.getDigest(bob, amount, nonce, deadline);
        console2.log("Digest A:");
        console2.logBytes32(digestA);
        console2.log("Digest B:");
        console2.logBytes32(digestB);

        vm.expectRevert(SignatureExecutor.InvalidSigner.selector);
        executor2.execute(
            bob,
            amount,
            nonce,
            deadline,
            signature
        );
    }
}