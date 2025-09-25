// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract votingSystem {

    struct candidate {
        uint8 id;
        string name;
        uint votes;
    }
    candidate [] public candidates;
    mapping (address => bool) public hasVoted;

    function createCandidate(uint8 _id, string memory _name) public {
        candidates.push(candidate(_id,_name,0));        
    }
    function voting(uint8 _id) public {
        require(!hasVoted[msg.sender], "You have already voted...");
        require(_id < candidates.length, "Candidate does not exists...");
        candidates[_id].votes++;
        hasVoted[msg.sender] = true;
    }
    function showWinner() public view returns(string memory winnerName,uint winnerVotes) {
        uint8 winnerId;
        uint highest;
        for (uint8 i = 0; i < candidates.length; i++) {
            if (candidates[i].votes > highest) {
                highest = candidates[i].votes;
                winnerId = i;
            }
        }
        winnerName = candidates[winnerId].name;
        winnerVotes = candidates[winnerId].votes;
    }
}