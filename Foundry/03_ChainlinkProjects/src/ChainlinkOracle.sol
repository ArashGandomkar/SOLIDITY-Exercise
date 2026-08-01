// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface AggregatorV3Interface {
    function decimals() external view returns (uint8);

    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );
}

import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

contract ChainlinkOracle {
    using Math for uint256;

    AggregatorV3Interface public immutable priceFeed;

    uint8 public immutable tokenDecimals;
    uint8 public immutable priceDecimals;
    uint8 public constant MAX_PRICE_DECIMALS = 36;
    uint8 public constant MAX_TOKEN_DECIMALS = 36;

    uint256 public immutable maxStaleness;

    error InvalidPrice();
    error ZeroAddress();
    error InvalidUpdatedAt();
    error InvalidTokenDecimals();
    error InvalidPriceDecimals();
    error StalePrice();

    constructor(address _priceFeed, uint8 _tokenDecimals, uint256 _maxStaleness) {

        if (_priceFeed == address(0)) {
            revert ZeroAddress();
        }
        if (_tokenDecimals > MAX_TOKEN_DECIMALS) {
            revert InvalidTokenDecimals();
        }
        priceFeed = AggregatorV3Interface(_priceFeed);
        tokenDecimals = _tokenDecimals;
        maxStaleness = _maxStaleness;
        priceDecimals = priceFeed.decimals();
        if (priceDecimals > MAX_PRICE_DECIMALS) {
            revert InvalidPriceDecimals();
        }
    }

    function getPrice() public view returns(uint256 price) {
        (
            ,
            int256 answer,
            ,
            uint256 updatedAt,

        ) = priceFeed.latestRoundData();
        if (answer <= 0) {
            revert InvalidPrice();
        }
        if (updatedAt == 0 || updatedAt > block.timestamp) {
            revert InvalidUpdatedAt();
        }
        if (block.timestamp - updatedAt > maxStaleness) {
            revert StalePrice();
        }
        uint256 rawPrice = uint256(answer);
        if (priceDecimals < 18) {
            price = Math.mulDiv(
                rawPrice,
                10 ** (18 - priceDecimals),
                1);
        } else if (priceDecimals > 18) {
            price = Math.mulDiv(
                rawPrice,
                1,
                10 ** (priceDecimals - 18),
                Math.Rounding.Floor);
        } else {
            price = rawPrice;
        }
    }

    function getValue(uint256 amount) external view returns (uint256 value) {
        uint256 price18 = getPrice();
        value = Math.mulDiv(
            amount,
            price18,
            10 ** tokenDecimals
        );
    }
}