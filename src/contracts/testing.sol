// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract testing is AccessControl {

    bytes32 public constant sensor_role = keccak256("sensor_role");
    bytes32 public constant owner_role = keccak256("owner_role");

    uint256 public totalSensors;  
    sensor [] public sensorList; 

    struct sensor {
        address sensorAddress; 
        int256 sensorData; 
    }

    function addSensorRole(address [] memory _sensor) public {
         for(uint i=0; i< _sensor.length; i++)
        {
            _sensor[i];
        }
    }

    function createAuthentication() public {
        require(hasRole(sensor_role, msg.sender));
    }

}
