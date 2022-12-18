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
}