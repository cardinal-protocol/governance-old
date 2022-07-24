// contracts/CardinalProtocol.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


/* ========== [IMPORT] ========== */

// /access
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";


contract CardinalProtocol is AccessControlEnumerable {

	/* ========== [STATE VARIABLES] ========== */

	// CONSTANT
	bytes32 public constant EXECUTIVE_ROLE = keccak256("EXECUTIVE_ROLE");
	bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
	bytes32 public constant MEMBER_ROLE = keccak256("MEMBER_ROLE");

	
	/* ========== [CONSTRUCTOR] ========== */

	constructor () {
		_setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
	}


	/* ========== [FUNCTIONS][VIEW] ========== */

	function authLevel_admin(address a) public view returns (bool) {
		return
			hasRole(DEFAULT_ADMIN_ROLE, a)
		;
	}

	function authLevel_executive(address a) public view returns (bool) {
		return
			hasRole(DEFAULT_ADMIN_ROLE, a) ||
			hasRole(EXECUTIVE_ROLE, a)
		;
	}

	function authLevel_manager(address a) public view returns (bool) {
		return
			hasRole(DEFAULT_ADMIN_ROLE, a) ||
			hasRole(EXECUTIVE_ROLE, a) ||
			hasRole(MANAGER_ROLE, a)
		;
	}

	function authLevel_member(address a) public view returns (bool) {
		return
			hasRole(DEFAULT_ADMIN_ROLE, a) ||
			hasRole(EXECUTIVE_ROLE, a) ||
			hasRole(MANAGER_ROLE, a) ||
			hasRole(MEMBER_ROLE, a)
		;
	}
}