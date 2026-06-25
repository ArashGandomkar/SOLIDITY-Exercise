// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Vault/Vault.sol";

contract VaultHandler is Test {
    Vault public vault;
    constructor(Vault _vault) {
        vault = _vault;
    }
    function _actor(uint256 seed) internal view returns(address) {
    address actor =
        address(uint160(bound(seed, 1, type(uint160).max)));

    if (actor == address(vault) || actor == address(0)) {
        actor = address(1);
    }
    return actor;
    }
    function deposit(uint256 actorSeed, uint256 amount) public {
        amount = bound(amount, 1 wei, 10 ether);

        address actor = _actor(actorSeed);
        vm.deal(actor, amount);
        vm.prank(actor);
        vault.deposit{value: amount}();
    }
    function withdraw(uint256 actorSeed, uint256 amount) public {
        address actor = _actor(actorSeed);
        amount = bound(amount, 0, 10 ether);

        uint256 balance = vault.balances(actor);
        if (balance >= amount && amount > 0) {
            vm.prank(actor);
            vault.withdraw(amount);
        }
    }
}
contract VaultInvariantTest is Test {
    Vault public vault;
    VaultHandler public handler;

    function setUp() public {
        vault = new Vault();
        handler = new VaultHandler(vault);

        targetContract(address(handler));
    }
    function invariant_VaultBalanceMatchesTotalDeposited() public view {
        assertEq(address(vault).balance, vault.totalDeposited());
    }
}