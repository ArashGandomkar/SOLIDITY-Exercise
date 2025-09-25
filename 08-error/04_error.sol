// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract errorD {

    string public status;
    uint8 stop = 100;
    function mainRevret(uint8 num) public {
        status = "Not Ok";
        if(num > stop) {
            revert("Number too big.");
        }
        status = "Ok";
    }
    function revretCustomError(uint8 num) public {
        status = "Not Ok";
        if(num > stop) {
            revert WrongNumber({
                errorStop : stop,
                errorNum : num
            });
        }
        status = "Ok";
    }
}
        error WrongNumber (uint8 errorStop, uint8 errorNum);