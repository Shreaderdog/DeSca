// File: contracts\desca.sol

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
        uint256 numSensors; // number of sensors associated with this node
        int256[] sensordata; // data from each sensor of node
        uint256[] noDataTimer; // count of cycles since data was last received from sensor
        bool[] ignore; // shows whether sensor can be ignored for final decision
        bool[] recd; // tracks whether data was received this cycle
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
        revokeRole(NET_ADMIN_ROLE, _adminAccount);
    }

    function addNode(address _nodeaddress) public {
        require(hasRole(NET_ADMIN_ROLE, msg.sender));
        grantRole(DATA_SENDER_ROLE, _nodeaddress);
        totalNodes += 1;
        node memory s = node(_nodeaddress, 0, new int256[](0), new uint256[](0),  new bool[](0),  new bool[](0) );
        nodeList.push(s);
        nodeIndex[_nodeaddress] = nodeList.length-1;
    }

    function removeNode(address _nodeaddress) public {
        require(hasRole(NET_ADMIN_ROLE, msg.sender));
        revokeRole(DATA_SENDER_ROLE, _nodeaddress);
    }

    function getNode(address _nodeaddress) internal view returns (node memory){
        return nodeList[nodeIndex[_nodeaddress]];
    }

    function getTotalSensors() external view returns (uint256) {
        return totalSensors;
    }

    function getFlightFlag() external view returns (bool) {
        return flightflag;
    }

    function reportData(int256[] calldata _sensordata) external {
        require(hasRole(DATA_SENDER_ROLE, msg.sender));

        node memory cnodeorig = nodeList[nodeIndex[msg.sender]];
        node memory currnode = node(cnodeorig.nodeAddress, _sensordata.length, _sensordata, new uint256[](_sensordata.length),  new bool[](_sensordata.length),  new bool[](_sensordata.length) );

        for(uint i = 0; i < cnodeorig.noDataTimer.length; i++) {
            
            currnode.noDataTimer[i] = cnodeorig.noDataTimer[i];
        }

        for (uint i = 0; i < _sensordata.length; i++) {

            if(_sensordata[i] == -100000) {
                currnode.noDataTimer[i] += 1;
                currnode.recd[i] = false;
            }
            else {
                currnode.noDataTimer[i] = 0;
                currnode.recd[i] = true;
                currnode.ignore[i] = false;
            }

            if(currnode.noDataTimer[i] >= sensorTimeout) {
                currnode.ignore[i] = true;
            }

            uint index = nodeIndex[msg.sender];
            nodeList[index] = currnode;
        }
        bool good = true;
        uint gooddata = 0;
        totalSensors = 0;
        for(uint j = 0; j < nodeList.length; j++) {
            totalSensors += nodeList[j].numSensors;
            for(uint k = 0; k < nodeList[j].numSensors; k++) {
                if(nodeList[j].recd[k] == false && nodeList[j].ignore[k] == false) {
                    good = false;
                }
                else if(nodeList[j].sensordata[k] < 8000 && nodeList[j].sensordata[k] > 4000) {
                    gooddata += 1;
                }
            }
            if(good == false) {
                break;
            }
        }

        if((gooddata*100)/totalSensors < targetPercentage) {
            good = false;
        }

        if(good) {
            flightflag = true;
        }
        else {
            flightflag = false;
        }
    }
}