// File: contracts\desca.sol

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract DeSCA is AccessControl {
    bytes32 public constant DAO_ROLE = keccak256("DAO_ROLE");

    enum VoterStatus { NOT_VALID, NOT_VOTED, YES, NO }
    enum VoteResult { NOT_VALID, PASSED, FAILED }

    VoteResult decision;
    uint decision_timestamp;
    uint num_voters;
    uint expected_voters;
    uint num_yes;
    uint num_no;
    mapping (address => VoterStatus) voter_votes;
    address[] voter_addresses;

    constructor (address admin_address, uint _expected_voters) {
        _setupRole(DEFAULT_ADMIN_ROLE, admin_address);

        decision = VoteResult.NOT_VALID;
        decision_timestamp = 0;
        num_voters = 1;
        expected_voters = _expected_voters;
        num_yes = 0;
        num_no = 0;
        voter_addresses = new address[](99);

        voter_addresses[0] = admin_address;
    }

    function addVoter(address voter) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender));

        if (voter_votes[voter] == VoterStatus.NOT_VALID) {
            voter_votes[voter] = VoterStatus.NOT_VOTED;
            voter_addresses[num_voters++] = voter;

            grantRole(DAO_ROLE, voter);
        }
    }

    function vote(address voter, bool vote) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender) || hasRole(DAO_ROLE, msg.sender));

        if (voter_votes[voter] == VoterStatus.NOT_VOTED) {
            if (vote) {
                voter_votes[voter] = VoterStatus.YES;

                num_yes++;
            } else {
                voter_votes[voter] = VoterStatus.NO;

                num_no++;
            }

            // Make DAO decision
            if ((num_yes + num_no) == expected_voters) {
                decision = !(num_no >= num_yes) ? VoteResult.PASSED : VoteResult.FAILED;
                decision_timestamp = block.timestamp;

                reset();
            }
        }
    }

    function print_status(address voter) public view returns (uint) {
        return uint(voter_votes[voter]);
    }

    function print_decision() public view returns (uint) {
        return uint(decision);
    }

    function print_time() public view returns(uint) {
        return decision_timestamp;
    }
 
    function reset() public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender));

        num_voters = 0;
        num_yes = 0;
        num_no = 0;

        for (uint i = 0; i < num_voters; i++) {
            voter_votes[voter_addresses[i]] = VoterStatus.NOT_VALID;
        }

        voter_addresses = new address[](99);
    }

    // function add(address voter) public returns (string memory) {
    //     test[voter] = false;
    //     testLength++;

    //     for (uint i = 0; i < testLength; i++) {
    //         testt = string(bytes.concat(bytes(testt),"t"));
    //     }
    // }
}