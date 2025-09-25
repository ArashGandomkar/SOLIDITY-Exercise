// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract enumB {

    enum Seasons {
        Spring,
        Summer,
        Fall,
        Winter
    }
    Seasons public season;
    constructor() {
        season = Seasons.Spring;
    }
    function nextSeason() public {
        season = Seasons.Summer;
    }
    function getSeason() public view returns(Seasons) {
        return season;
    }
}