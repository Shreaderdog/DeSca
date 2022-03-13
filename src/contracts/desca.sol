//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract DeSCA is AccessControl {
    //roles
    bytes32 public constant DATA_SENDER_ROLE = keccak256("DATA_SENDER_ROLE");
    bytes32 public constant DRONE_CONTROLLER_ROLE = keccak256("DRONE_CONTROLLER_ROLE");
    bytes32 public constant CONTRACT_EDITOR_ROLE = keccak256("CONTRACT_EDITOR_ROLE");

    //node struct
    struct node {
        address nodeAddress; // blockchain address
        int256 nodeData; // received data
        uint256 noDataTimer; // counts cycles since data received
        bool dataReceived; // has send data this cycle
    }

    //datastore
    uint256 public totalNodes;  // total nodes on network
    uint256 public functionalNodes; // nodes not timed out
    uint256 public targetPercentage; // percentage of nodes above threshold
    uint256 public nodeTimeout; // number of times node can not send data before being skipped
    bool public flightflag; // flag for sending drone out
    node[] public nodeList; // holds all nodes
    

    constructor(uint256 _targetpercent, uint256 _timeout) {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        totalNodes = 0;
        targetPercentage = _targetpercent;
        nodeTimeout = _timeout;
        flightflag = false;
    }

    function addnode(address _nodeaddress) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender));
        if(functionalNodes < totalNodes) {
            nodeList.push(node({nodeAddress: _nodeaddress, nodeData: 0, noDataTimer: 0, dataReceived: false}));
            grantRole(DATA_SENDER_ROLE, _nodeaddress);
            functionalNodes += 1;
            totalNodes += 1;
        }
    }
}