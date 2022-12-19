// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


/* [IMPORT] */
// @openzeppelin/contracts/access
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";

/* [IMPORT] Internal */
import "./interface/ICardinalProtocolGovernance.sol";


/*    _________    ____  ____  _____   _____    __       ____  ____  ____  __________  __________  __ 
*   / ____/   |  / __ \/ __ \/  _/ | / /   |  / /      / __ \/ __ \/ __ \/_  __/ __ \/ ____/ __ \/ / 
*  / /   / /| | / /_/ / / / // //  |/ / /| | / /      / /_/ / /_/ / / / / / / / / / / /   / / / / /  
* / /___/ ___ |/ _, _/ /_/ // // /|  / ___ |/ /___   / ____/ _, _/ /_/ / / / / /_/ / /___/ /_/ / /___
* \____/_/  |_/_/ |_/_____/___/_/ |_/_/  |_/_____/  /_/   /_/ |_|\____/ /_/  \____/\____/\____/_____/
*/


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