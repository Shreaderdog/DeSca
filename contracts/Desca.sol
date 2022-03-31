//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract DeSCA is AccessControl {
    //roles
    bytes32 public constant DATA_SENDER_ROLE = keccak256("DATA_SENDER_ROLE");
    bytes32 public constant DAO_ROLE = keccak256("DAO_ROLE");
    bytes32 public constant NET_ADMIN_ROLE = keccak256("NET_ADMIN_ROLE");
    
    struct node {
        address nodeAddress; // blockchain address of node
        int256 numSensors; // number of sensors associated with this node
        int256[] sensordata; // data from each sensor of node
        int256[] noDataTimer; // count of cycles since data was last received from sensor
        bool[] dataRecieved; // tracks whether data was received this cycle
        bool[] ignore; // shows whether sensor can be ignored for final decision
    }

    uint256 public totalNodes; // number of nodes on network
    uint256 public totalSensors; // number of sensors across all nodes
    uint256 public targetPercentage; // percentage of sensors above threshold
    uint256 public sensorTimeout; // number of times no data can be received before deactivating sensor requirement
    bool public flightflag; // flag for DAO to see if preflight passed
    node[] public nodeList; // list of all nodes
    mapping(address => uint256) nodeIndex;

    constructor(uint256 _targetpercent, uint256 _timeout) {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        totalNodes = 0;
        targetPercentage = _targetpercent;
        sensorTimeout = _timeout;
        flightflag = false;
        _setRoleAdmin(DATA_SENDER_ROLE, NET_ADMIN_ROLE);
    }

    function addAdmin(address _adminAccount) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender));
        grantRole(NET_ADMIN_ROLE, _adminAccount);
    }

    function removeAdmin(address _adminAccount) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender));
        revokeRole(NET_ADMIN_ROLE, msg.sender);
    }

    function addNode(address _nodeaddress) public {
        require(hasRole(NET_ADMIN_ROLE, msg.sender));
        grantRole(DATA_SENDER_ROLE, msg.sender);
        totalNodes += 1;
        nodeList.push(node({nodeAddress: _nodeaddress, numSensors: 0}));
    }

    function removeNode(address _nodeaddress) public {
        require(hasRole(NET_ADMIN_ROLE, msg.sender));
        revokeRole(DATA_SENDER_ROLE, msg.sender);   
    }

    function reportData(int256[] calldata _sensordata) external {
        require(hasRole(DATA_SENDER_ROLE, msg.sender));
        if(nodeList[nodeIndex[msg.sender]].numSensors < _sensordata.length) {
            nodeList[nodeIndex[msg.sender]].numSensors = _sensordata.length;
        }
        for (uint i = 0; i < _sensordata.length; i++) {
            if(i == nodeList[nodeIndex[msg.sender]].sensordata.length) {
                nodeList[nodeIndex[msg.sender]].sensordata.push(_sensordata[i]);
            }
            else {
                nodeList[nodeIndex[msg.sender]].sensordata[i] = _sensordata[i];
            }

            if(_sensordata[i] == -100000) {
                if(i == nodeList[nodeIndex[msg.sender]].sensordata.length) {
                    nodeList[nodeIndex[msg.sender]].noDataTimer.push(1);
                }
                else {
                    nodeList[nodeIndex[msg.sender]].noDataTimer[i] += 1;
                }

                if(i == nodeList[nodeIndex[msg.sender]].sensordata.length) {
                    nodeList[nodeIndex[msg.sender]].dataReceived.push(false);
                }
                else {
                    nodeList[nodeIndex[msg.sender]].dataReceived[i] = false;
                }
            }
            else {
                if(i == nodeList[nodeIndex[msg.sender]].sensordata.length) {
                    nodeList[nodeIndex[msg.sender]].noDataTimer.push(0);
                }
                else {
                    nodeList[nodeIndex[msg.sender]].noDataTimer[i] = 0;
                }
                
                if(i == nodeList[nodeIndex[msg.sender]].sensordata.length) {
                    nodeList[nodeIndex[msg.sender]].dataReceived.push(true);
                }
                else {
                    nodeList[nodeIndex[msg.sender]].dataReceived[i] = true;
                }

                if(i == nodeList[nodeIndex[msg.sender]].sensordata.length) {
                    nodeList[nodeIndex[msg.sender]].ignore.push(false);
                }
                else {
                    nodeList[nodeIndex[msg.sender]].ignore[i] = false;
                }
            }

            if(nodeList[nodeIndex[msg.sender]].noDataTimer[i] >= sensorTimeout) {
                nodeList[nodeIndex[msg.sender]].ignore[i] = true;
            }
            
            bool good = true;
            for(uint i = 0; i < nodeList.length; i++) {
                for(uint j = 0; i < nodeList[i].numSensors; i++) {
                    if(nodeList[i].dataReceived[j] == false && nodeList[i].ignore[j] == false) {
                        good = false;
                    }
                    else if(nodeList[i].sensordata[j] > 8000 || nodeList[i].sensordata[j] < 4000) {
                        good = false;
                    }
                }
                if(good == false) {
                    break;
                }
            }

            if(good) {
                flightflag = true;
            }
            else {
                flightflag = false; 
            }
        }
    }
}