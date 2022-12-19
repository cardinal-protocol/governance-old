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
	/**
	* @notice AccessControl Role
	* @return {bytes32} keccak256 value
	*/
	function S() external view returns (bytes32);

	/**
	* @notice AccessControl Role
	* @return {bytes32} keccak256 value
	*/
	function A() external view returns (bytes32);

	/**
	* @notice AccessControl Role
	* @return {bytes32} keccak256 value
	*/
	function B() external view returns (bytes32);

	/**
	* @notice AccessControl Role
	* @return {bytes32} keccak256 value
	*/
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
	/// @inheritdoc ICardinalProtocolGovernance
	bytes32 public constant S = keccak256("S");
	/// @inheritdoc ICardinalProtocolGovernance
	bytes32 public constant A = keccak256("A");
	/// @inheritdoc ICardinalProtocolGovernance
	bytes32 public constant B = keccak256("B");
	/// @inheritdoc ICardinalProtocolGovernance
	bytes32 public constant C = keccak256("C");


	/* [CONSTRUCTOR] */
	constructor ()
	{
		_setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
	}
}