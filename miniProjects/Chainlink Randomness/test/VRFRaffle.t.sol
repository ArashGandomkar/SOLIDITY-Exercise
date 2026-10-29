
 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";

import {VRFRaffle} from "../src/VRFRaffle.sol";

import {
    VRFCoordinatorV2_5Mock
} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

contract VRFRaffleTest is Test {
    VRFCoordinatorV2_5Mock coordinator;
    VRFRaffle raffle;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    address charlie = makeAddr("charlie");

    uint256 subId;

    function setUp() public {
        // 1. Create Coordinator test
        coordinator = new VRFCoordinatorV2_5Mock(
            0.1 ether,
            1e9,
            1e18
        );

        // 2. Create Subscription
        subId = coordinator.createSubscription();

        // 3. Fund smart contract
        coordinator.fundSubscription(
            subId,
            uint96(100 ether)
        );

        // 4. Create Raffle
        raffle = new VRFRaffle(
            address(this),
            address(coordinator),
            subId,
            bytes32(uint256(123)),
            100
        );

        coordinator.addConsumer(
            subId,
            address(raffle)
        );
    }

    function test_UsersCanEnter() public {
        vm.prank(alice);
        raffle.enter();

        vm.prank(bob);
        raffle.enter();
        assertEq(raffle.playersCount(1), 2);
        assertEq(raffle.playerAt(1, 0), alice);
        assertEq(raffle.playerAt(1, 1), bob);
        
    }

    function test_CannotRequestWithoutPlayers() public {
        vm.expectRevert();

        raffle.requestWinner();
    }

    function test_CannotEnterWhileRandomnessPending() public {
        vm.prank(alice);
        raffle.enter();

        raffle.requestWinner();
        (
            ,
            ,
        VRFRaffle.RaffleState _state,
        ) = raffle.getRoundInfo(1);
        assertEq(uint256(_state),
        uint256(VRFRaffle.RaffleState.Calculating));

        vm.expectRevert();

        vm.prank(bob);
        raffle.enter();
    }

    function test_WinnerSelectedAfterFulfillment() public {
        vm.prank(alice);
        raffle.enter();

        vm.prank(bob);
        raffle.enter();

        vm.prank(charlie);
        raffle.enter();

        raffle.requestWinner();
        (
            address _winner,
            ,
            ,
        ) = raffle.getRoundInfo(1);
        assertEq(_winner, address(0));

        (
            ,
            ,
        VRFRaffle.RaffleState _state,
        ) = raffle.getRoundInfo(1);
        assertEq(uint256(_state),
        uint256(VRFRaffle.RaffleState.Calculating));

        uint256[] memory words = new uint256[](1);
        words[0] = 1;
        assertEq(uint256(_state),
        uint256(VRFRaffle.RaffleState.Calculating));

        (
            ,
            uint256 _requestId,
            ,
        ) = raffle.getRoundInfo(1);
        coordinator.fulfillRandomWordsWithOverride(
            _requestId,
            address(raffle),
            words
        );

        (
            _winner,
            ,
            ,
        ) = raffle.getRoundInfo(1);
        assertEq(_winner, bob);

        (
            ,
            ,
            _state,
        ) = raffle.getRoundInfo(1);
        assertEq(uint256(_state),
        uint256(VRFRaffle.RaffleState.Closed));
    }

    function test_CannotEnterTwice() public {
        vm.prank(alice);
        raffle.enter();

        vm.prank(bob);
        raffle.enter();

        vm.expectRevert();
        vm.prank(alice);
        raffle.enter();
    }

    function test_CannotRequestWinnerTwice() public {
        vm.prank(alice);
        raffle.enter();
        raffle.requestWinner();

        (
            ,
            ,
        VRFRaffle.RaffleState _state,
        ) = raffle.getRoundInfo(1);
        assertEq(uint256(_state),
        uint256(VRFRaffle.RaffleState.Calculating));

        vm.expectRevert();
        raffle.requestWinner();
    }

    function test_CannotRequestAfterWinnerSelected() public {
        vm.prank(alice);
        raffle.enter();
        raffle.requestWinner();

        uint256[] memory words = new uint256[](1);
        words[0] = 0;

        (
            ,
            ,
        VRFRaffle.RaffleState _state,
        ) = raffle.getRoundInfo(1);
        assertEq(uint256(_state),
        uint256(VRFRaffle.RaffleState.Calculating));

        (
            ,
            uint256 _requestId,
            ,
        ) = raffle.getRoundInfo(1);
        coordinator.fulfillRandomWordsWithOverride(
            _requestId,
            address(raffle),
            words
        );

        (
            address _winner,
            ,
            ,
        ) = raffle.getRoundInfo(1);
        assertEq(_winner, alice);

        (
            ,
            ,
            _state,
        ) = raffle.getRoundInfo(1);
        assertEq(uint256(_state),
        uint256(VRFRaffle.RaffleState.Closed));
        vm.expectRevert();
        raffle.requestWinner();
    }
    function test_OnlyOwnerCanStartRaffle() public {
        vm.prank(bob);
        raffle.enter();

        vm.expectRevert();
        vm.prank(bob);
        raffle.requestWinner();

        raffle.requestWinner();

        (
            ,
            ,
        VRFRaffle.RaffleState _state,
        ) = raffle.getRoundInfo(1);
        assertEq(uint256(_state),
        uint256(VRFRaffle.RaffleState.Calculating));
    }

    function test_CannotEnterWhenRaffleIsFull() public {
        for (uint256 i = 1; i <= 100; i++) {
            address player = address(uint160(i));

            vm.prank(player);
            raffle.enter();
        }

        assertEq(raffle.playersCount(1), 100);

        address extraPlayer = makeAddr("extraPlayer");

        vm.expectRevert(VRFRaffle.RaffleFull.selector);
        vm.prank(extraPlayer);
        raffle.enter();
        assertEq(raffle.playersCount(1), 100);
        
    }


    function test_UserCanEnterAgainInNextRound() public {
        // دور اول
        vm.prank(alice);
        raffle.enter();
    
        vm.prank(bob);
        raffle.enter();
    
        raffle.requestWinner();
    
        (
            ,
            uint256 firstRequestId,
            ,
        ) = raffle.getRoundInfo(1);
    
        uint256[] memory words = new uint256[](1);
        words[0] = 1;
    
        coordinator.fulfillRandomWordsWithOverride(
            firstRequestId,
            address(raffle),
            words
        );
    
        assertEq(raffle.currentRoundId(), 2);
    
        (
            address firstWinner,
            ,
            VRFRaffle.RaffleState firstState,
            uint256 firstPlayerCount
        ) = raffle.getRoundInfo(1);
    
        assertEq(firstWinner, bob);
        assertEq(
            uint256(firstState),
            uint256(VRFRaffle.RaffleState.Closed)
        );
        assertEq(firstPlayerCount, 2);
    
        vm.prank(alice);
        raffle.enter();
    
        assertEq(raffle.playersCount(2), 1);
        assertEq(raffle.playerAt(2, 0), alice);
    
        (address winnerAfterSecondEntry, , , ) =
            raffle.getRoundInfo(1);
    
        assertEq(winnerAfterSecondEntry, bob);
    }

    function test_SecondRoundCanComplete() public {
        vm.prank(alice);
        raffle.enter();

        raffle.requestWinner();

        (
            ,
            uint requestId1,
            ,
        ) = raffle.getRoundInfo(1);
        uint256[] memory words = new uint256[](1);
        words[0] = 0;

        coordinator.fulfillRandomWordsWithOverride(
            requestId1,
            address(raffle),
            words
        );
        assertEq(raffle.currentRoundId(), 2);

        vm.prank(bob);
        raffle.enter();

        raffle.requestWinner();

        (
        ,
        uint256 requestId2,
        VRFRaffle.RaffleState state2,
        uint256 count2
        ) = raffle.getRoundInfo(2);

        assertTrue(requestId2 != 0);
        assertEq(uint256(state2), uint256(VRFRaffle.RaffleState.Calculating));
        assertEq(count2, 1);

        words[0] = 0;
        coordinator.fulfillRandomWordsWithOverride(
            requestId2,
            address(raffle),
            words
        );

        (
        address winner2,
        ,
        VRFRaffle.RaffleState finalState2,
        uint256 finalCount2
        ) = raffle.getRoundInfo(2);

        assertEq(winner2, bob);
        assertEq(uint256(finalState2), uint256(VRFRaffle.RaffleState.Closed));
        assertEq(finalCount2, 1);
        assertEq(raffle.currentRoundId(), 3);

        (
            ,
            ,
            VRFRaffle.RaffleState state3,
            uint256 count3
        ) = raffle.getRoundInfo(3);

        assertEq(uint256(VRFRaffle.RaffleState.Open), uint256(state3));
        assertEq(count3, 0);
    }


    function test_CannotRetryBeforeTimeout() public {
        vm.prank(alice);
        raffle.enter();

        raffle.requestWinner();

        vm.expectRevert(VRFRaffle.RequestNotTimedOut.selector);
        raffle.retryRequest();
    }


    function test_LateResponseFromOldRequestIsIgnored() public {
        vm.prank(alice);
        raffle.enter();

        vm.prank(bob);
        raffle.enter();

        raffle.requestWinner();

        (
            ,
            uint256 oldRequestId,
            ,
        ) = raffle.getRoundInfo(1);

        vm.warp(
            block.timestamp + raffle.REQUEST_TIMEOUT() + 1
        );

        raffle.retryRequest();

        (
            ,
            uint256 newRequestId,
            VRFRaffle.RaffleState state,
        ) = raffle.getRoundInfo(1);

        assertTrue(newRequestId != oldRequestId);
        assertEq(
            uint256(state),
            uint256(VRFRaffle.RaffleState.Calculating)
        );

        uint256[] memory oldWords = new uint256[](1);
        oldWords[0] = 0;

        coordinator.fulfillRandomWordsWithOverride(
            oldRequestId,
            address(raffle),
            oldWords
        );

        (
            address winnerAfterOldResponse,
            ,
            VRFRaffle.RaffleState state2,
        ) = raffle.getRoundInfo(1);

        assertEq(winnerAfterOldResponse, address(0));
        assertEq(
            uint256(state2),
            uint256(VRFRaffle.RaffleState.Calculating)
        );
        assertEq(raffle.currentRoundId(), 1);

        uint256[] memory newWords = new uint256[](1);
        newWords[0] = 1;

        coordinator.fulfillRandomWordsWithOverride(
            newRequestId,
            address(raffle),
            newWords
        );

        (
            address finalWinner,
            uint256 ignoredRequestId,
            VRFRaffle.RaffleState state3,
        ) = raffle.getRoundInfo(1);

        assertEq(finalWinner, bob);
        assertEq(
            uint256(state3),
            uint256(VRFRaffle.RaffleState.Closed)
        );
        assertEq(raffle.currentRoundId(), 2);
    }
}
