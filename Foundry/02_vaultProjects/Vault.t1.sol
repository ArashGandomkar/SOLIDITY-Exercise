// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Vault/Vault.sol";

contract VaultTest1 is Test {
    Vault public vault;
    address owner = address(1);
    address user = address(2);

    function setUp() public {
        vault = new Vault();
    }
    function testDepositFuzz(uint256 amount) public {
        amount = bound(amount, 1 ether, 10 ether);
        vm.deal(address(this), amount);
        vault.Deposit{value: amount}();
        assertEq(address(vault).balance, amount);
    }
}