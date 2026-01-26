// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Escrow {

    address public recrituer;
    address payable public freelancer;
    uint endTime;
    uint amount;

    enum Status {
        AWAITING_PAYMENT,
        AWAITING_DELIVERY,
        DELIVERED,
        ACCEPTED,
        COMPLETED
    }
    Status public currentStatus;

    event ProjectDelivered(address _freelancer, uint _time);
    event FundDeposited(address _recrituer, uint _amount);
    event ProjectCompeleted(address _freelancer, address _recrituer, uint _amount, uint _time);

    modifier onlyRecrituer {
        require(msg.sender == recrituer, "only Recrituer can do this.");
        _;
    }
    modifier onlyFreelancer {
        require(msg.sender == freelancer, "only Freelancer can do this.");
        _;
    }
    constructor(address _recrituer, address _freelancer, uint _endTime, uint _amount) {
        recrituer = _recrituer;
        freelancer = payable(_freelancer);
        amount = _amount;
        endTime = block.timestamp + _endTime;
    }

    function deposit() public payable onlyRecrituer {
        require(msg.value >= amount, "Deposit must be at least == Escrow amount.");
        currentStatus = Status.AWAITING_DELIVERY;
        emit FundDeposited(msg.sender, msg.value);
    }
    function deliverProject() public onlyFreelancer returns(bool) {
        require(currentStatus == Status.AWAITING_DELIVERY, "Project not funded yet.");
        require(block.timestamp <= endTime, "Project time error.");
        currentStatus = Status.DELIVERED;
        emit ProjectDelivered(msg.sender, block.timestamp);
        return true;
    }
    function acceptProject() public onlyRecrituer returns(bool) {
        require(currentStatus == Status.DELIVERED, "Project not delivered yet.");
        currentStatus = Status.ACCEPTED;
        return true;
    }
    function withdrawEscrowFunds() public onlyFreelancer {
        require(currentStatus == Status.ACCEPTED, "Project not accepted yet.");
        (bool sent, ) = freelancer.call{value : amount}("");
        require(sent, "Failed to sent Escrow funds.");
        currentStatus = Status.COMPLETED;
        emit ProjectCompeleted(freelancer, recrituer, amount, block.timestamp);
    }
}