// File: contracts\desca.sol

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract DeSCA is AccessControl {
    bytes32 public constant DAO_ROLE = keccak256("DAO_ROLE");

    enum VoterStatus { NOT_VALID, NOT_VOTED, YES, NO }
    enum VoteResult { NOT_VALID, PASSED, FAILED }

    VoteResult decision; // Keeps track of last DAO decision
    uint decision_timestamp; // Keeps track of the time the last DAO decision was made
    uint num_voters; // Number of voters currently in the DAO
    uint expected_voters; // Number of voters expected to vote in the DAO
    uint num_yes; // Number of yes votes
    uint num_no; // Number of no votes
    mapping (address => VoterStatus) voter_votes; // Dictionary used to keep each voters vote
    address[] voter_addresses; // Array used to store the DAO voters addresses (used to index the voter_votes dictionary)

    constructor (address admin_address, uint _expected_voters) {
        _setupRole(DEFAULT_ADMIN_ROLE, admin_address);

        decision = VoteResult.NOT_VALID;
        decision_timestamp = 0;
        num_voters = 0;
        expected_voters = _expected_voters;
        num_yes = 0;
        num_no = 0;
        voter_addresses = new address[](99);

        // Add admin to DAO system
        setupVoter(admin_address);
    }

    // Function used to setup a DAO voter
    // So sets up their role, status, and address log
    function setupVoter(address voter) private {
        if (voter_votes[voter] == VoterStatus.NOT_VALID) {
            voter_votes[voter] = VoterStatus.NOT_VOTED;
            voter_addresses[num_voters++] = voter;

            grantRole(DAO_ROLE, voter);
        }
    }

    // Function used to reset variables used for the DAO
    function resetDAO() private {
        for (uint i = 0; i < num_voters; i++) {
            voter_votes[voter_addresses[i]] = VoterStatus.NOT_VALID;
        }
        
        num_voters = 0;
        num_yes = 0;
        num_no = 0;

        voter_addresses = new address[](99);
    }

    // Function used by the DAO admin to add DAO voters
    function addVoter(address voter) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender));

        setupVoter(voter);
    }

    // Function used by the DAO voters to vote
    function vote(bool vote) public {
        require(hasRole(DAO_ROLE, msg.sender));

        if (voter_votes[msg.sender] == VoterStatus.NOT_VOTED) {
            if (vote) {
                voter_votes[msg.sender] = VoterStatus.YES;

                num_yes++;
            } else {
                voter_votes[msg.sender] = VoterStatus.NO;

                num_no++;
            }

            // Make DAO decision
            if ((num_yes + num_no) == expected_voters) {
                decision = !(num_no >= num_yes) ? VoteResult.PASSED : VoteResult.FAILED;
                decision_timestamp = block.timestamp;

                resetDAO();
            }
        }
    }

    // Function used by the DAO admin to reset the DAO variables
    function reset() public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender));

        resetDAO();
    }

    function print_status() public view returns (uint) {
        return uint(voter_votes[msg.sender]);
    }

    function print_decision() public view returns (uint) {
        return uint(decision);
    }

    function print_time() public view returns(uint) {
        return decision_timestamp;
    }
}