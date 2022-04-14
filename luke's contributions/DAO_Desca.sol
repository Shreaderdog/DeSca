// File: contracts\dao_desca.sol

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract DAO_DeSCA is AccessControl, ReentrancyGuard {
    //roles
    bytes32 public constant NON_DAO = keccak256("NON_DAO");
    bytes32 public constant DAO_ROLE = keccak256("DAO_ROLE");
    uint constant minimumVotingPeriod = 2 minutes; // 
    unit256 numOfProposals; // keeps track of how many times the system has called for a vote
    
    struct votingSystem {
        uint256 proposalID; // the unique ID value of each new voting proposal
        address proposalAddress; // blockchain address of each voting proposal
        string proposalDescription; // describes the proposal addressed, maybe provide user with sensor data to make informed decision

        address voterAddress; //holds the address of people who are voting in the proposal
        int256[] votedFor; //count of votes in favor of flying 
        int256[] votedAgainst; //count of votes opposed to flying 
        bool[] hasVoted; // value showing whether or not an individual has voted
        
        bool[] votingPassed; // value determining wether or not votesFor > votesAgainst
    }


    //possible approach 

    //user added as DAO_Role
    // if DAO_Role, proceed to voting page {
        // if DAO_Role votes for flying { 
            // tally votes in votesFor 
            // switch user voted status to yes 
            // check if everyone has voted
            // if vote status on all participants is yes AND votes for > votes against{
                // assign voting pass check to true
                // "fly" drone}} 
        // else if DAO-Role votes against flying{
            //tally in vote against
            // switch user stattus to yes
            //check if all have voted 
            // if vote status on all participants is yes and votes against > votes for{
                // assign voting pass check to flase
                // "do not fly drone"}}
        // reset all vote stauses to no after 1 minute, reset voting page  