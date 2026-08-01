// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";

import "../src/ChainlinkOracle.sol";
import "../src/MockAggregator.sol";

contract ChainlinkOracleTest is Test {
    MockAggregator internal mock;
    ChainlinkOracle internal oracle;

    function setUp() public {
        vm.warp(100 days);
        mock = new MockAggregator(8, 2500e8, block.timestamp);
        oracle = new ChainlinkOracle(address(mock), 18, 1 hours);
    }
    function test_GetPriceReturnsNormalizedPrice() public view {
        uint256 price = oracle.getPrice();
        assertEq(price, 2500e18);
    }

    function test_RevertsWhenPriceIsNegative() public {
        mock.setPrice(-1, block.timestamp);
        vm.expectRevert(ChainlinkOracle.InvalidPrice.selector);
        oracle.getPrice();
    }

    function test_RevertsWhenPriceIsStale() public {
        mock.setPrice(2500e8, block.timestamp - 2 hours);
        vm.expectRevert(ChainlinkOracle.StalePrice.selector);
        oracle.getPrice();
    }

    function test_GetPriceWith18DecimalsFeed() public {
        MockAggregator mock18 = new MockAggregator(18, 2500e18, block.timestamp);
        ChainlinkOracle oracle18 = new ChainlinkOracle(address(mock18), 18, 1 hours);

        uint256 price = oracle18.getPrice();
        assertEq(price, 2500e18);
    }

    function test_GetPriceWith20DecimalsFeed() public {
        MockAggregator mock20 = new MockAggregator(
            20,
            2500e20,
            block.timestamp
        );
        ChainlinkOracle oracle20 = new ChainlinkOracle(
            address(mock20),
            18,
            1 hours
        );
        uint256 price = oracle20.getPrice();
        assertEq(price, 2500e18);
    }

    function test_GetValueForZeroAmount() public {
        uint256 value = oracle.getValue(0);
        assertEq(value, 0);
    }

    function test_GetValueIsLinear() public {
        uint256 value1 = oracle.getValue(2e18);
        uint256 value2 = oracle.getValue(4e18);
        assertEq(value2, value1 * 2);
    }

    function testFuzz_GetValueIsLinear(uint96 amount) public {
        vm.assume(amount <= type(uint96).max / 2);
        uint256 value1 = oracle.getValue(amount);
        uint256 value2 = oracle.getValue(amount * 2);
        assertEq(value2, value1 * 2);
    }
}