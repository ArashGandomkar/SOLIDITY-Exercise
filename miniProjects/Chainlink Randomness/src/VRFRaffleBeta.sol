
 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {
    VRFConsumerBaseV2Plus
} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";

import {
    VRFV2PlusClient
} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

contract VRFRaffle is VRFConsumerBaseV2Plus {
    enum RaffleState {
        Open,
        Calculating,
        Closed
    }
    address[] public players;

    address public winner;
    uint256 public requestId;
    bool public raffleOpen = true;
    uint256 public immutable maxPlayers;
    RaffleState public raffleState;
    uint256 public subscriptionId;
    bytes32 public keyHash;
    uint32 public callbackGasLimit = 100000;
    uint16 public requestConfirmations = 3;

    mapping(uint256 => bool) public knownRequest;
    mapping(address => bool) public knownPlayer;

    event PlayerEntered(address indexed player);
    event RandomnessRequested(uint256 indexed requestId);
    event WinnerSelected(address indexed winner);
    event RaffleClosed(uint256 indexed requestId);

    error InvalidMaxPlayers();
    error RaffleNotOpen();
    error RaffleNotCalculating();
    error NoPlayers();
    error AlreadyEntered();
    error RaffleFull();
    error InvalidRequest();
    error InvalidRandomWords();

    constructor(
        address initialOwner,
        address coordinator,
        uint256 subId,
        bytes32 _keyHash,
        uint256 _maxPlayers
    ) VRFConsumerBaseV2Plus(coordinator) {
        if (_maxPlayers == 0) revert InvalidMaxPlayers();
        subscriptionId = subId;
        keyHash = _keyHash;
        maxPlayers = _maxPlayers;
        raffleState = RaffleState.Open;
        if (initialOwner != owner()) {
        transferOwnership(initialOwner);
        }
    }

    function enter() external {
        if (raffleState != RaffleState.Open) {
            revert RaffleNotOpen();
        }
        if (knownPlayer[msg.sender]) {
            revert AlreadyEntered();
        }
        if (players.length >= maxPlayers) {
            revert RaffleFull();
        }

        players.push(msg.sender);
        knownPlayer[msg.sender] = true;
        emit PlayerEntered(msg.sender);
    }

    function requestWinner() external onlyOwner {
        if (raffleState != RaffleState.Open) {
            revert RaffleNotOpen();
        }
        if (players.length == 0) revert NoPlayers();

        raffleState = RaffleState.Calculating;

        uint256 id = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: keyHash,
                subId: subscriptionId,
                requestConfirmations: requestConfirmations,
                callbackGasLimit: callbackGasLimit,
                numWords: 1,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({
                        nativePayment: false
                    })
                )
            })
        );

        requestId = id;
        knownRequest[id] = true;

        emit RandomnessRequested(id);
    }

    function fulfillRandomWords(
        uint256 id,
        uint256[] calldata randomWords
    ) internal override {
        if (!knownRequest[id] || 
            raffleState != RaffleState.Calculating ||
            id != requestId) {
            return;
        }

        knownRequest[id] = false;
        uint256 winnerIndex = randomWords[0] % players.length;
        winner = players[winnerIndex];

        raffleState = RaffleState.Closed;
        

        emit WinnerSelected(winner);
        emit RaffleClosed(id);
    }

    function playersCount() external view returns (uint256) {
        return players.length;
    }
}