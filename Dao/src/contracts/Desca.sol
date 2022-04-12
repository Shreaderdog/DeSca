// File: contracts\desca.sol

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract DeSCA is AccessControl {
    // function to reset data
    // data to hold if users have voted
    // data to hold users votes
    // dict[id] = vote
    // vote function, takes in bool for vote
    // array for indexes, array for values, array for ids (make sure indexs are consistent) 
    // check if user has voted before

    bytes32 public constant DAO_ROLE = keccak256("DAO_ROLE");

    enum VoterValue { NOT_VALID, NOT_VOTED, YES, NO }

    uint num_voters;
    uint num_yes;
    uint num_no;
    mapping (address => VoterValue) voter_votes;

    constructor (address admin) {
        _setupRole(DEFAULT_ADMIN_ROLE, admin);

        num_voters = 0;
        num_yes = 0;
        num_no = 0;
    }

    function addVoter(address voter) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender));

        if (voter_votes[voter] == VoterValue.NOT_VALID) {
            voter_votes[voter] = VoterValue.NOT_VOTED;
            grantRole(DAO_ROLE, voter);

            num_voters++;
        }
    }

    function vote(address voter, bool vote) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender) || hasRole(DAO_ROLE, msg.sender));

        if (voter_votes[voter] == VoterValue.NOT_VOTED) {
            if (vote) {
                voter_votes[voter] = VoterValue.YES;

                num_yes++;
            } else {
                voter_votes[voter] = VoterValue.NO;

                num_no++;
            }
        }
    }

    function decide() private view returns (bool) {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender));

        if ((num_yes + num_no) == num_voters) {
            return !(num_no >= num_yes);
        }
    }

    function reset() public view returns (address) {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender));

        num_voters = 0;
        num_yes = 0;
        num_no = 0;

        for (uint i = 0; i < num_voters; i++) {
            return voter_votes[i];
        }
    }

    // function print() public view returns (bool) {
    //     return decide();
    // }

    // function add(address voter) public returns (string memory) {
    //     test[voter] = false;
    //     testLength++;

    //     for (uint i = 0; i < testLength; i++) {
    //         testt = string(bytes.concat(bytes(testt),"t"));
    //     }
    // }
}