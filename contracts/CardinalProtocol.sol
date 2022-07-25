// contracts/CardinalProtocol.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;


/* ========== [IMPORT] ========== */

// @openzeppelin/contracts/access
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";


/*
 *    _________    ____  ____  _____   _____    __  
 *   / ____/   |  / __ \/ __ \/  _/ | / /   |  / /  
 *  / /   / /| | / /_/ / / / // //  |/ / /| | / /   
 * / /___/ ___ |/ _, _/ /_/ // // /|  / ___ |/ /___ 
 * \____/_/  |_/_/ |_/_____/___/_/_|_/_/__|_/_____/ 
 *    / __ \/ __ \/ __ \/_  __/ __ \/ ____/ __ \/ / 
 *   / /_/ / /_/ / / / / / / / / / / /   / / / / /  
 *  / ____/ _, _/ /_/ / / / / /_/ / /___/ /_/ / /___
 * /_/   /_/ |_|\____/ /_/  \____/\____/\____/_____/
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