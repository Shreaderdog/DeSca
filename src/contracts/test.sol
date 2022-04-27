// File: contracts\desca.sol

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract DescaTEST is AccessControl {
    bytes32 public constant DATA_SENDER_ROLE = keccak256("DATA_SENDER_ROLE");
    bytes32 public constant DAO_ROLE = keccak256("DAO_ROLE");
    bytes32 public constant NET_ADMIN_ROLE = keccak256("NET_ADMIN_ROLE");

    struct sensor {
        int256[] data;
        uint256 noDataTimer;
        bool ignore;
    }

    struct node {
        uint256 numSensors;
        uint256[] sensorsIDs;
    }

    struct outputdata {
        int256[] outdata;
    }

    uint cyclesensors;
    uint256 totalNodes;
    uint256 totalSensors;
    uint256 targetPercentage;
    uint256 sensorTimeout;
    bool flightflag;
    mapping(uint256 => sensor) sensors;
    mapping(address => node) nodes;
    address[] nodeIDs;

    constructor(uint256 _targetpercent, uint256 _timeout) {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        cyclesensors = 0;
        totalNodes = 0;
        totalSensors = 0;
        targetPercentage = _targetpercent;
        sensorTimeout = _timeout;
        flightflag = false;
        _setRoleAdmin(DATA_SENDER_ROLE, NET_ADMIN_ROLE);
    }

    function addAdmin(address _adminaccount) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender));
        grantRole(NET_ADMIN_ROLE, _adminaccount);
    }

    function removeAdmin(address _adminAccount) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender));
        revokeRole(NET_ADMIN_ROLE, _adminAccount);
    }

    function addNode(address _nodeaddress) public {
        require(hasRole(NET_ADMIN_ROLE, msg.sender));
        grantRole(DATA_SENDER_ROLE, _nodeaddress);
        totalNodes++;
        nodeIDs.push(_nodeaddress);
        nodes[_nodeaddress] = node(0, new uint256[](0));
    }

    function removeNode(address _nodeaddress) public {
        require(hasRole(NET_ADMIN_ROLE, msg.sender));
        revokeRole(DATA_SENDER_ROLE, _nodeaddress);
        totalNodes--;
        for(uint i = 0; i < nodeIDs.length; i++) {
            if(nodeIDs[i] == _nodeaddress) {
                nodeIDs[i] = nodeIDs[nodeIDs.length -1];
                delete nodeIDs[nodeIDs.length -1];
            }
        }
    }

    function getTotalSensors() external view returns (uint256) {
        return totalSensors;
    }

    function getFlightFlag() external view returns (bool) {
        return flightflag;
    }

    function getData() external view returns (outputdata[] memory) {
        outputdata[] memory q = new outputdata[] (totalSensors);
        for(uint i = 0; i < totalSensors; i++) {
            outputdata memory output =  outputdata(new int256[](0));
            output.outdata = sensors[i].data;
            q[i] = output;
        }
        return q;
    }

    function reportData(int256[] calldata _sensordata) external {
        require(hasRole(DATA_SENDER_ROLE, msg.sender));

        node memory temp = nodes[msg.sender];
        for(uint i = 0; i < _sensordata.length; i++) {
            if(i < nodes[msg.sender].numSensors) {
                sensors[temp.sensorsIDs[i]].data.push(_sensordata[i]);
                if (_sensordata[i] == -100000) {
                sensors[temp.sensorsIDs[i]].noDataTimer++;
                uint x = sensors[temp.sensorsIDs[i]].noDataTimer;
                    if (x > sensorTimeout) {
                        sensors[temp.sensorsIDs[i]].ignore = true;
                    }
                }
                else {
                sensors[temp.sensorsIDs[i]].noDataTimer = 0;
                sensors[temp.sensorsIDs[i]].ignore = false;
                }
            }
            else {
                nodes[msg.sender].numSensors++;
                totalSensors++;
                nodes[msg.sender].sensorsIDs.push(totalSensors);
                sensors[totalSensors].data.push(_sensordata[i]);
                if (_sensordata[i] == -100000) {
                    sensors[totalSensors].noDataTimer++;
                }
                else {
                    sensors[totalSensors].noDataTimer = 0;
                    sensors[totalSensors].ignore = false;
                }
            }
        }
        cyclesensors += _sensordata.length;

        if (cyclesensors == totalSensors) {
            uint gooddata = 0;
            for(uint i = 0; i < totalSensors; i++) {
                if(!(sensors[i].ignore)) {
                    uint len = sensors[i].data.length;
                    if (sensors[i].data[len-1] < 8000 && sensors[i].data[len-1] > 4000) {
                        gooddata++;
                    }
                }
            }

            if ((gooddata*100)/totalSensors < targetPercentage) {
                flightflag = true;
            }
            else {
                flightflag = false;
            }
            cyclesensors == 0;
        }
    }
}