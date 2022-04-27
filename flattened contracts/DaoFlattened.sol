// File: node_modules\@openzeppelin\contracts\access\IAccessControl.sol


// OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)

pragma solidity ^0.8.0;

/**
 * @dev External interface of AccessControl declared to support ERC165 detection.
 */
interface IAccessControl {
    /**
     * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
     *
     * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
     * {RoleAdminChanged} not being emitted signaling this.
     *
     * _Available since v3.1._
     */
    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);

    /**
     * @dev Emitted when `account` is granted `role`.
     *
     * `sender` is the account that originated the contract call, an admin role
     * bearer except when using {AccessControl-_setupRole}.
     */
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Emitted when `account` is revoked `role`.
     *
     * `sender` is the account that originated the contract call:
     *   - if using `revokeRole`, it is the admin role bearer
     *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
     */
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Returns `true` if `account` has been granted `role`.
     */
    function hasRole(bytes32 role, address account) external view returns (bool);

    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {AccessControl-_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) external view returns (bytes32);

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function grantRole(bytes32 role, address account) external;

    /**
     * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function revokeRole(bytes32 role, address account) external;

    /**
     * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been granted `role`, emits a {RoleRevoked}
     * event.
     *
     * Requirements:
     *
     * - the caller must be `account`.
     */
    function renounceRole(bytes32 role, address account) external;
}

// File: node_modules\@openzeppelin\contracts\utils\Context.sol


// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: node_modules\@openzeppelin\contracts\utils\Strings.sol


// OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)

pragma solidity ^0.8.0;

/**
 * @dev String operations.
 */
library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
}

// File: node_modules\@openzeppelin\contracts\utils\introspection\IERC165.sol


// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File: node_modules\@openzeppelin\contracts\utils\introspection\ERC165.sol


// OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)

pragma solidity ^0.8.0;


/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 *
 * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
 */
abstract contract ERC165 is IERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

// File: @openzeppelin\contracts\access\AccessControl.sol


// OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControl.sol)

pragma solidity ^0.8.0;





/**
 * @dev Contract module that allows children to implement role-based access
 * control mechanisms. This is a lightweight version that doesn't allow enumerating role
 * members except through off-chain means by accessing the contract event logs. Some
 * applications may benefit from on-chain enumerability, for those cases see
 * {AccessControlEnumerable}.
 *
 * Roles are referred to by their `bytes32` identifier. These should be exposed
 * in the external API and be unique. The best way to achieve this is by
 * using `public constant` hash digests:
 *
 * ```
 * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
 * ```
 *
 * Roles can be used to represent a set of permissions. To restrict access to a
 * function call, use {hasRole}:
 *
 * ```
 * function foo() public {
 *     require(hasRole(MY_ROLE, msg.sender));
 *     ...
 * }
 * ```
 *
 * Roles can be granted and revoked dynamically via the {grantRole} and
 * {revokeRole} functions. Each role has an associated admin role, and only
 * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
 *
 * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
 * that only accounts with this role will be able to grant or revoke other
 * roles. More complex role relationships can be created by using
 * {_setRoleAdmin}.
 *
 * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
 * grant and revoke this role. Extra precautions should be taken to secure
 * accounts that have been granted it.
 */
abstract contract AccessControl is Context, IAccessControl, ERC165 {
    struct RoleData {
        mapping(address => bool) members;
        bytes32 adminRole;
    }

    mapping(bytes32 => RoleData) private _roles;

    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;

    /**
     * @dev Modifier that checks that an account has a specific role. Reverts
     * with a standardized message including the required role.
     *
     * The format of the revert reason is given by the following regular expression:
     *
     *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
     *
     * _Available since v4.1._
     */
    modifier onlyRole(bytes32 role) {
        _checkRole(role, _msgSender());
        _;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
    }

    /**
     * @dev Returns `true` if `account` has been granted `role`.
     */
    function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
        return _roles[role].members[account];
    }

    /**
     * @dev Revert with a standard message if `account` is missing `role`.
     *
     * The format of the revert reason is given by the following regular expression:
     *
     *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
     */
    function _checkRole(bytes32 role, address account) internal view virtual {
        if (!hasRole(role, account)) {
            revert(
                string(
                    abi.encodePacked(
                        "AccessControl: account ",
                        Strings.toHexString(uint160(account), 20),
                        " is missing role ",
                        Strings.toHexString(uint256(role), 32)
                    )
                )
            );
        }
    }

    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
        return _roles[role].adminRole;
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
        _grantRole(role, account);
    }

    /**
     * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
        _revokeRole(role, account);
    }

    /**
     * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been revoked `role`, emits a {RoleRevoked}
     * event.
     *
     * Requirements:
     *
     * - the caller must be `account`.
     */
    function renounceRole(bytes32 role, address account) public virtual override {
        require(account == _msgSender(), "AccessControl: can only renounce roles for self");

        _revokeRole(role, account);
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event. Note that unlike {grantRole}, this function doesn't perform any
     * checks on the calling account.
     *
     * [WARNING]
     * ====
     * This function should only be called from the constructor when setting
     * up the initial roles for the system.
     *
     * Using this function in any other way is effectively circumventing the admin
     * system imposed by {AccessControl}.
     * ====
     *
     * NOTE: This function is deprecated in favor of {_grantRole}.
     */
    function _setupRole(bytes32 role, address account) internal virtual {
        _grantRole(role, account);
    }

    /**
     * @dev Sets `adminRole` as ``role``'s admin role.
     *
     * Emits a {RoleAdminChanged} event.
     */
    function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
        bytes32 previousAdminRole = getRoleAdmin(role);
        _roles[role].adminRole = adminRole;
        emit RoleAdminChanged(role, previousAdminRole, adminRole);
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * Internal function without access restriction.
     */
    function _grantRole(bytes32 role, address account) internal virtual {
        if (!hasRole(role, account)) {
            _roles[role].members[account] = true;
            emit RoleGranted(role, account, _msgSender());
        }
    }

    /**
     * @dev Revokes `role` from `account`.
     *
     * Internal function without access restriction.
     */
    function _revokeRole(bytes32 role, address account) internal virtual {
        if (hasRole(role, account)) {
            _roles[role].members[account] = false;
            emit RoleRevoked(role, account, _msgSender());
        }
    }
}

// File: src\contracts\DESCATWO.sol

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


contract DeSCA is AccessControl {
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
}

// File: src\contracts\Dao.sol

pragma solidity ^0.8.0;



contract Dao is AccessControl {
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
    DeSCA sensors;

    constructor (uint _expected_voters, address _sensoraddress) {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);

        decision = VoteResult.NOT_VALID;
        decision_timestamp = 0;
        num_voters = 0;
        expected_voters = _expected_voters;
        num_yes = 0;
        num_no = 0;
        voter_addresses = new address[](99);

        // Add admin to DAO system
        setupVoter(msg.sender);
        sensors = DeSCA(_sensoraddress);
    }

    // Function used to setup a DAO voter
    // So sets up their role, status, and address log
    function setupVoter(address _voter) private {
        if (voter_votes[_voter] == VoterStatus.NOT_VALID) {
            voter_votes[_voter] = VoterStatus.NOT_VOTED;
            voter_addresses[num_voters++] = _voter;

            grantRole(DAO_ROLE, _voter);
        }
    }

    // Function used to reset variables used for the DAO
    function resetDAO() private {
        for (uint i = 1; i < num_voters; i++) {
            voter_votes[voter_addresses[i]] = VoterStatus.NOT_VALID;
            delete voter_addresses[i];
        }
        
        voter_votes[voter_addresses[0]] = VoterStatus.NOT_VOTED;
        num_voters = 1;
        num_yes = 0;
        num_no = 0;

    }

    function resetVotes() private {
        for (uint i = 0; i < num_voters; i++) {
            voter_votes[voter_addresses[i]] = VoterStatus.NOT_VOTED;
        }

        num_yes = 0;
        num_no = 0;

    }

    // Function used by the DAO admin to add DAO voters
    function addVoter(address _voter) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender));

        setupVoter(_voter);
    }

    // Function used by the DAO voters to vote
    function vote(bool _vote) public {
        require(hasRole(DAO_ROLE, msg.sender));

        if (voter_votes[msg.sender] == VoterStatus.NOT_VOTED) {
            if (_vote) {
                voter_votes[msg.sender] = VoterStatus.YES;

                num_yes++;
            } else {
                voter_votes[msg.sender] = VoterStatus.NO;

                num_no++;
            }

            // Make DAO decision
            if ((num_yes + num_no) == expected_voters) {
                // Add sensor data decision to DAO votes
                sensors.getFlight() ? num_yes++ : num_no++;

                // Make DAO decision
                decision = !(num_no >= num_yes) ? VoteResult.PASSED : VoteResult.FAILED;
                decision_timestamp = block.timestamp;

                // Cleanup DAO variables once decision has been made
                resetVotes();
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
        return 5;//uint(decision);
    }

    function print_time() public view returns(uint) {
        return decision_timestamp;
    }

    function get_decision() public view returns (bool) {
        if (decision == VoteResult.PASSED) {
            return true;
        }
        else {
            return false;
        }
    }
}
