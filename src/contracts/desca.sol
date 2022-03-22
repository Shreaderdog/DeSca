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
    mapping(address => uint256) nodeIndex;
    

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
            nodeIndex[_nodeaddress] = totalNodes;
            functionalNodes += 1;
            totalNodes += 1;
        }
    }

    function removenode(address _nodeaddress) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender));
        uint256 i;
        for(i = 0; i < nodeList.length; i++) {
            if(nodeList[i].nodeAddress == _nodeaddress) {
                nodeList[i] = nodeList[nodeList.length - 1];  // move last element to empty space
                delete nodeList[nodeList.length - 1];  // remove empty space where last element was
                functionalNodes -= 1;
            }
        }
    }

    function reportdata(int256 _sensordata) public {
        require(hasRole(DATA_SENDER_ROLE, msg.sender));
        nodeList[nodeIndex[msg.sender]].nodeData = _sensordata;
        nodeList[nodeIndex[msg.sender]].noDataTimer = 0;
        nodeList[nodeIndex[msg.sender]].dataReceived = true;
    }
}