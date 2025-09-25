// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract structA {
    
    struct University {
        uint8 id;
        string name;
        bool available;
    }
    University uni1 = University(1,"Fasa",true);
    University uni2;

    function set(uint8 id1, string memory name1, bool test) public {

        uni2 = University(id1,name1,test);
    }
    function show(uint8 num) public view returns(uint8, string memory, bool) {
        if(num == 1) {
            return(uni1.id,uni1.name,uni1.available);
        }
        else if(num == 2) {
        return(uni2.id,uni2.name,uni2.available);
        }
        else {
            revert("Your number out of range...");
        }
    }
}