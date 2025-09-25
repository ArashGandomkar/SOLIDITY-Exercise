// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

interface CreateToken {

    function totalSupply() external view returns(uint);
    function balanceOf(address tokenOwner) external view returns(uint);
    function allowance(address owner, address spender) external view returns(uint);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
    
    function transfer(address recipient, uint amount) external returns(bool);
    function transferFrom(address sender, address recipient, uint amount) external returns(bool);
    function approve(address spender, uint amount) external returns(bool);
}

contract ArashGk is CreateToken {

    using SafeMath for uint;

    string public Name;
    uint public TotalSupply;
    uint8 public Decimals;
    string public Symbol;

    mapping (address => uint) balances;
    mapping (address => mapping (address => uint)) allowed;


    constructor() {
        Name = "ArashGk";
        Symbol = "AGK";
        Decimals = 4;
        TotalSupply = 10000000000;
        balances[msg.sender] = TotalSupply;
    }
    function totalSupply() public override  view returns(uint) {
        return TotalSupply;
    }
    function balanceOf(address tokenOwner) public override view returns(uint) {
        return balances[tokenOwner];
    }
    function allowance(address owner, address delegate) public override  view returns(uint) {
        return allowed[owner][delegate];
    }
    function transfer(address reciver, uint numTokens) public override returns(bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[reciver] = balances[reciver].add(numTokens);
        emit Transfer(msg.sender, reciver, numTokens);
        return true;
    }
    function transferFrom(address owner, address reciver, uint numTokens) public  override returns(bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);
        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[reciver] = balances[reciver].add(numTokens);
        emit Transfer(owner, reciver, numTokens);
        return true;
    }
    function approve(address delegate, uint numTokens) public override  returns(bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }
}

library SafeMath {

    function sub(uint a, uint b) internal  pure returns(uint) {
        assert(a <= b);
        return a - b;
    }
    function add(uint a, uint b) internal pure returns(uint) {
        uint c = a + b;
        assert(c >= a);
        return c;
    }
}