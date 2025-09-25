// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract structB {

    struct student {
        uint8 num;
        string name;
        bool pass;
    }
    student public stu1 = student({num: 1, name: "Arash", pass: true});
    student public stu2 = student(2,"Ali",false);
    student []public students;

    function add(uint8 num1, string memory name1, bool pass1) public {

        students.push(student(3,"Reza",false));
        students.push(student(num1,name1,pass1));
    }
    function deleteuser(uint8 num) public {
        delete students[num];
    }
}