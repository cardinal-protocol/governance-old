// contracts/CardinalProtocolToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


/* ========== [IMPORT] ========== */
// @openzeppelin/contracts/token
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
// @openzeppelin/contracts/security
import "@openzeppelin/contracts/security/Pausable.sol";


/* ========== [IMPORT][PERSONAL] ========== */
import "./abstract/CardinalProtocolController.sol";


contract CardinalProtocolToken is ERC20Capped, Pausable, CardinalProtocolController {
	/* ========== [DEPENDENCIES] ========== */
	using SafeERC20 for CardinalProtocolToken;


	/* ========== [EVENTS] ========== */
	event SupplyAmountSet(
		uint amount,
		address byOwner
	);


	/* ========== [CONSTRUCTOR] ========== */
	constructor (address cardinalProtocolAddress_)
		ERC20("Cardinal Protocol Token", "CPT")
		ERC20Capped(100 * 1000000 * 1e18)
		CardinalProtocolController(cardinalProtocolAddress_)
	{}


	/* ========== [FUNCTIONS][MUTATIVE] ========== */
	/*
	* Auth Level: _chief 
	*/
	function mint(address _to, uint256 _amount) external
		authLevel_chief()
		whenNotPaused()
	{
		// Call ERC20Capped "_mint" function
		super._mint(_to, _amount);
	}

	/*
	* Auth Level: _manager
	*/
	function pause() public
		authLevel_manager()
		whenNotPaused()
	{
		// Call Pausable "_pause" function
		super._pause();
	}

	function unpause() public
		authLevel_manager()
		whenNotPaused()
	{
		// Call Pausable "_unpause" function
		super._unpause();
	}
}