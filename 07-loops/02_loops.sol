// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract loopsB1 {

    uint8 [] data;
    uint8 num = 0;
    function loop1() public returns(uint8[] memory) {
        for(num = 0; num < 5; num++) {
            if(num == 3) {
                continue;
            }
            data.push(num);
        }
        return  data;
    }
}
contract loopsB2 {

    uint8 [] data;
    uint8 num = 0;
    function loop2() public returns(uint8[] memory) {
        while(num < 5) {
            num++;
            if(num == 3) {
                continue;
            }
            data.push(num);
        }
        return  data;
    }
}
contract loopsB3 {

    uint8 [] data;
    uint8 num = 0;
    function loop3() public returns(uint8[] memory) {
        do {
            num++;
            if(num == 3) {
                break;
            }
            data.push(num);
        } while(num < 5);
        return  data;
    }
}