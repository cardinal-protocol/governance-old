// contracts/CardinalProtocolGovernance.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


/* [IMPORT] */
// @openzeppelin/contracts/access
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";


contract CardinalProtocolGovernance is AccessControlEnumerable {
	/* [STATE VARIABLES] */
	bytes32 public constant S = keccak256("S");
	bytes32 public constant A = keccak256("A");
	bytes32 public constant B = keccak256("B");
	bytes32 public constant C = keccak256("C");


	/* [CONSTRUCTOR] */
	constructor () {
		_setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
	}

	/* ========== [FUNCTIONS][VIEW] ========== */
	function authLevel_admin(address caller) public view returns (bool) {
		return
			hasRole(DEFAULT_ADMIN_ROLE, caller)
		;
	}

	function authLevelS(address caller) public view returns (bool) {
		return
			hasRole(DEFAULT_ADMIN_ROLE, caller) ||
			hasRole(S, caller)
		;
	}

	function authLevelA(address caller) public view returns (bool) {
		return
			hasRole(DEFAULT_ADMIN_ROLE, caller) ||
			hasRole(S, caller) ||
			hasRole(A, caller)
		;
	}

	function authLevelB(address caller) public view returns (bool) {
		return
			hasRole(DEFAULT_ADMIN_ROLE, caller) ||
			hasRole(S, caller) ||
			hasRole(A, caller) ||
			hasRole(B, caller)
		;
	}

	function authLevelC(address caller) public view returns (bool) {
		return
			hasRole(DEFAULT_ADMIN_ROLE, caller) ||
			hasRole(S, caller) ||
			hasRole(A, caller) ||
			hasRole(B, caller) ||
			hasRole(C, caller)
		;
	}
}