// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


/* [IMPORT] */
// @openzeppelin/contracts/access
import "@cardinal-protocol/v1-sdk/contracts/interface/ICardinalProtocolGovernance.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";


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