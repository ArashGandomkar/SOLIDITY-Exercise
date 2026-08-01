// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ChainlinkOracle.sol";

contract MockAggregator is AggregatorV3Interface {
    uint8 private immutable i_decimals;
    int256 private s_answer;
    uint256 private s_updatedAt;

    constructor(uint8 decimals_, int256 answer_, uint256 updatedAt_) {
        i_decimals = decimals_;
        s_answer = answer_;
        s_updatedAt = updatedAt_;
    }

    function decimals() external view override returns (uint8) {
        return i_decimals;
    }

    function latestRoundData() external view override
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        ) {
        return (
            1,
            s_answer,
            0,
            s_updatedAt,
            1
        );
    }
    
    function setPrice(int256 answer_, uint256 updatedAt_) external {
        s_answer = answer_;
        s_updatedAt = updatedAt_;
    }
}