// contracts/CardinalProtocolGovernance.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


/* [IMPORT] */
// @openzeppelin/contracts/access
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";


/**
* @title ICardinalProtocolGovernance
*/
interface ICardinalProtocolGovernance
{
	/* [STATE VARIABLES] */
	function S() external view returns (bytes32);
	function A() external view returns (bytes32);
	function B() external view returns (bytes32);
	function C() external view returns (bytes32);
}


/**
* @title CardinalProtocolGovernance
*/
contract CardinalProtocolGovernance is
	AccessControlEnumerable,
	ICardinalProtocolGovernance
{
	/* [STATE VARIABLES] */
	bytes32 public constant S = keccak256("S");
	bytes32 public constant A = keccak256("A");
	bytes32 public constant B = keccak256("B");
	bytes32 public constant C = keccak256("C");


	/* [CONSTRUCTOR] */
	constructor ()
	{
		_setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
	}
}