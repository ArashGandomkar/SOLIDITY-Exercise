// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract enumA {

    enum Week {

        Saturday,
        Sunday,
        Monday,
        Tuesday,
        Wednesday,
        Thursday,
        Friday
    }
    Week public choice;
    Week constant public default_value = Week.Friday;

    function set() public {

        choice = Week.Sunday;
    } 
    function get() public view returns(Week){
        return choice;
    }
    function getDefaultValue() public pure returns(Week) {
        return default_value;
    }
}