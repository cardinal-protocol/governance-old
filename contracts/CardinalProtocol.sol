// contracts/CardinalProtocol.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;


/* ========== [IMPORT] ========== */

// @openzeppelin/contracts/access/..
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/AccessControlEnumerable.sol";

/*
 *   ________   ___  ___  _____  _____   __     ___  ___  ____  __________  _________  __ 
 *  / ___/ _ | / _ \/ _ \/  _/ |/ / _ | / /    / _ \/ _ \/ __ \/_  __/ __ \/ ___/ __ \/ / 
 * / /__/ __ |/ , _/ // // //    / __ |/ /__  / ___/ , _/ /_/ / / / / /_/ / /__/ /_/ / /__
 * \___/_/ |_/_/|_/____/___/_/|_/_/ |_/____/ /_/  /_/|_|\____/ /_/  \____/\___/\____/____/
 *                                                                                        
*/
contract CardinalProtocol is AccessControlEnumerable {

	/* ========== [STATE VARIABLES] ========== */

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