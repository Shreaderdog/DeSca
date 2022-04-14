// File: contracts\desca_governance_token.sol

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/extensons/ERC20Votes.sol";

contract DAO_Governance_Token is ERC20Votes {
    uint256 public s_maxsupply = 1,000,000

    constructor() ERC20("DAO_Governance_Token", "DAOGT"){
        _mint(msg.sender, s_maxSupply); 
    }
}