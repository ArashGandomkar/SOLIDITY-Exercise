// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract mappingC {

     enum Level {
        Easy,Regular,Hard
    }
    mapping (address => Level) public map;
    
    function set(address addr, Level level) public {
        map[addr] = level;
    }
    function get(address addr) public  view returns(Level) {
        return map[addr];
    }
}