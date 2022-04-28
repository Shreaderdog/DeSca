//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract DeSCATWO is AccessControl {
    bytes32 public constant SENSOR_ROLE = keccak256("SENSOR_ROLE");
    bytes32 public constant DAO_ROLE = keccak256("DAO_ROLE");
    bytes32 public constant NET_ADMIN_ROLE = keccak256("NET_ADMIN_ROLE");

    uint256 totalSensors;
    uint256 targetPercentage;
    uint256 sensorTimeout;
    bool lastResult;
    int256[] sensorData;
    bool[] recd;
    uint256[] timer;
    mapping(address => uint256) sensorMap;

    constructor(uint256 _targetPercent, uint256 _timeout) {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        totalSensors = 0;
        targetPercentage = _targetPercent;
        sensorTimeout = _timeout;
        lastResult = false;
        _setRoleAdmin(SENSOR_ROLE, NET_ADMIN_ROLE);
    }
    
    function setupDAO(address _daoaddress) external {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender));
        grantRole(DAO_ROLE, _daoaddress);
    }

    function addAdmin(address _adminAccount) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender));
        grantRole(NET_ADMIN_ROLE, _adminAccount);
    }

    function addSensor(address _sensorAddress) public {
        require(hasRole(NET_ADMIN_ROLE, msg.sender));
        grantRole(SENSOR_ROLE, _sensorAddress);
        totalSensors++;
        sensorData.push(-100000);
        sensorMap[_sensorAddress] = sensorData.length - 1;
        recd.push(false);
        timer.push(0);
    }

    function reportData(int256 _sensorData) external {
        require(hasRole(SENSOR_ROLE, msg.sender));
        uint256 index = sensorMap[msg.sender];
        sensorData[index] = _sensorData;
        if (_sensorData == -100000) {
            recd[index] = false;
            timer[index]++;
        }
        else {
            recd[index] = true;
            timer[index] = 0;
        }
    }

    function getFlight() external returns (bool) {
        require(hasRole(DAO_ROLE, msg.sender));
        uint yes = 0;
        int data;

        if(totalSensors == 0) {
            return false;
        }

        for (uint i = 0; i < sensorData.length - 1; i++) {
            data = sensorData[i];
            if(data > 4000 && data < 8000 && recd[i]) {
                yes++;
            }
            recd[i] = false;
        }
        if((yes*100)/totalSensors > targetPercentage) {
            lastResult = true;
            return true;
        }
        else {
            lastResult = false;
            return false;
        }
    }

    function getData() external view returns (int[] memory) {
        return sensorData;
    }

    function getTotalSensors() external view returns (uint) {
        return totalSensors;
    }

    function getLastResult() external view returns (bool) {
        return lastResult;
    }

    function getTimer() external view returns (uint[] memory) {
        return timer;
    }

    function getRecd() external view returns (bool[] memory) {
        return recd;
    }

    function descaInfo() external view returns (uint, int[] memory, bool, uint[] memory, bool[] memory) {
        return (totalSensors, sensorData, lastResult, timer, recd);
    }
}