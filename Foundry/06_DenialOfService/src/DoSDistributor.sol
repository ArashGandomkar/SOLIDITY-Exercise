
 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VulnerableDistributor {
    address[] public users;
    uint256 public constant REWARD = 1 ether;

    constructor(address[] memory _users) payable {
        users = _users;
    }

    function distribute() external {
        require(
            address(this).balance >= users.length * REWARD,
            "Insufficient balance"
        );

        for (uint256 i = 0; i < users.length; i++) {
            payable(users[i]).transfer(REWARD);
        }
    }

    function usersCount() external view returns (uint256) {
        return users.length;
    }

    receive() external payable {}
}

contract MaliciousReceiver {
    receive() external payable {
        revert("I refuse ETH");
    }
}

contract PullPaymentDistributor {
    mapping(address => uint256) public rewards;
    
    constructor(address[] memory users) payable {
        require(
            address(this).balance >= users.length * 1 ether,
            "Insufficient funding"
        );

        for (uint256 i = 0; i < users.length; i++) {
            rewards[users[i]] += 1 ether;
        }
    }

    function claim() external {
        uint256 amount = rewards[msg.sender];
        require(amount > 0, "No reward");
        rewards[msg.sender] = 0;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Payment failed");
    }

    receive() external payable {}
}