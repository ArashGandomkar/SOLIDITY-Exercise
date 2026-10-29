
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

    struct Round {
        address[] players;
        address winner;
        uint256 requestId;
        RaffleState state;
        uint256 requestTimestamp;
    }

    uint256 public currentRoundId = 1;
    uint256 public immutable maxPlayers;

    uint256 public subscriptionId;
    bytes32 public keyHash;

    uint32 public callbackGasLimit = 100000;
    uint16 public requestConfirmations = 3;
    uint256 public constant REQUEST_TIMEOUT = 1 days;

    mapping(uint256 => Round) private rounds;

    mapping(uint256 => mapping(address => bool)) public entered;

    mapping(uint256 => uint256) public requestToRound;

    error InvalidMaxPlayers();
    error RaffleNotOpen();
    error NoPlayers();
    error AlreadyEntered();
    error RaffleFull();
    error InvalidRequest();
    error InvalidRandomWords();
    error RequestNotTimedOut();
    error NoActiveRequest();


    event PlayerEntered(
        uint256 indexed roundId,
        address indexed player
    );

    event RandomnessRequested(
        uint256 indexed roundId,
        uint256 indexed requestId
    );

    event WinnerSelected(
        uint256 indexed roundId,
        address indexed winner
    );

    event RequestRetried(
        uint256 indexed roundId,
        uint256 indexed oldRequestId,
        uint256 indexed newRequestId
    );

    event RaffleClosed(uint256 indexed roundId);

    event NewRoundStarted(uint256 indexed roundId);

    constructor(
        address initialOwner,
        address coordinator,
        uint256 subId,
        bytes32 _keyHash,
        uint256 _maxPlayers
    ) VRFConsumerBaseV2Plus(coordinator) {
        if (_maxPlayers == 0) revert InvalidMaxPlayers();

        maxPlayers = _maxPlayers;
        subscriptionId = subId;
        keyHash = _keyHash;

        if (initialOwner != owner()) {
            transferOwnership(initialOwner);
        }

        rounds[currentRoundId].state = RaffleState.Open;

        emit NewRoundStarted(currentRoundId);
    }

    function enter() external {
        Round storage round = rounds[currentRoundId];

        if (round.state != RaffleState.Open) {
            revert RaffleNotOpen();
        }

        if (entered[currentRoundId][msg.sender]) {
            revert AlreadyEntered();
        }

        if (round.players.length >= maxPlayers) {
            revert RaffleFull();
        }

        round.players.push(msg.sender);
        entered[currentRoundId][msg.sender] = true;

        emit PlayerEntered(currentRoundId, msg.sender);
    }

    function requestWinner() external onlyOwner {
        Round storage round = rounds[currentRoundId];

        if (round.state != RaffleState.Open) {
            revert RaffleNotOpen();
        }

        if (round.players.length == 0) {
            revert NoPlayers();
        }

        round.state = RaffleState.Calculating;

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

        round.requestId = id;
        requestToRound[id] = currentRoundId;
        round.requestTimestamp = block.timestamp;

        emit RandomnessRequested(currentRoundId, id);
    }

    function retryRequest() external onlyOwner {
        uint256 roundId = currentRoundId;
        Round storage round = rounds[roundId];

        if (round.state != RaffleState.Calculating) {
            revert RequestNotTimedOut();
        }
        uint256 oldRequestId = round.requestId;

        if (oldRequestId == 0) {
            revert NoActiveRequest();
        }

        if (block.timestamp < 
        round.requestTimestamp + REQUEST_TIMEOUT) {
            revert RequestNotTimedOut(); 
        }

        delete requestToRound[oldRequestId];
        round.requestId = 0;

        uint256 newRequestId = s_vrfCoordinator.requestRandomWords(
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

        round.requestId = newRequestId;
        round.requestTimestamp = block.timestamp;
        requestToRound[newRequestId] = roundId;

        emit RequestRetried(
            roundId,
            oldRequestId,
            newRequestId
        );

        emit RandomnessRequested(roundId, newRequestId);
    }

    function fulfillRandomWords(
        uint256 id,
        uint256[] calldata randomWords
    ) internal override {
        uint256 roundId = requestToRound[id];

        if (roundId == 0) return;

        Round storage round = rounds[roundId];

        if (
            round.state != RaffleState.Calculating ||
            round.requestId != id
        ) {
            return;
        }

        if (randomWords.length == 0 || round.players.length == 0) {
            revert InvalidRandomWords();
        }

        uint256 winnerIndex = randomWords[0] % round.players.length;
        address selectedWinner = round.players[winnerIndex];

        round.winner = selectedWinner;
        round.state = RaffleState.Closed;

        delete requestToRound[id];

        emit WinnerSelected(roundId, selectedWinner);
        emit RaffleClosed(roundId);

        currentRoundId += 1;
        rounds[currentRoundId].state = RaffleState.Open;

        emit NewRoundStarted(currentRoundId);
    }

    function playersCount(uint256 roundId)
        external
        view
        returns (uint256)
    {
        return rounds[roundId].players.length;
    }

    function playerAt(uint256 roundId, uint256 index)
        external
        view
        returns (address)
    {
        return rounds[roundId].players[index];
    }

    function getRoundInfo(uint256 roundId)
        external
        view
        returns (
            address roundWinner,
            uint256 roundRequestId,
            RaffleState state,
            uint256 playerCount
        )
    {
        Round storage round = rounds[roundId];

        return (
            round.winner,
            round.requestId,
            round.state,
            round.players.length
        );
    }
}
