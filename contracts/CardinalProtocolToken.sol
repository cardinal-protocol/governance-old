// contracts/CardinalProtocolToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


/* ========== [IMPORT] ========== */

// /token
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
// /security
import "@openzeppelin/contracts/security/Pausable.sol";


/* ========== [IMPORT][PERSONAL] ========== */

import "./interface/ICardinalProtocol.sol";


contract CardinalProtocolToken is ERC20Capped, Pausable {
    /* ========== [DEPENDENCIES] ========== */

    using SafeERC20 for CardinalProtocolToken;


    /* ========== [EVENTS] ========== */

    event SupplyAmountSet(
        uint amount,
        address byOwner
    );


    /* ========== [STATE VARIABLES] ========== */

    address public CARDINAL_PROTOCOL_ADDRESS;

    
    /* ========== [CONSTRUCTOR] ========== */

    constructor (address cardinalProtocolAddress)
        ERC20("Cardinal Protocol Token", "CPT")
        ERC20Capped(100 * 1000000 * 1e18)
    {
        CARDINAL_PROTOCOL_ADDRESS = cardinalProtocolAddress;
    }

    
    /* ========== [MODIFIERS] ========== */
    
    modifier auth_owner() {
		// Require that the caller can only by the AssetAllocators Contract
		require(
			msg.sender == ICardinalProtocol(CARDINAL_PROTOCOL_ADDRESS).owner(),
			"!auth"
		);

		_;
	}

    modifier pauserOnly(address a) {
        require(ICardinalProtocol(CARDINAL_PROTOCOL_ADDRESS).isPauser(a), "!auth");

        _;
    }


	/* ========== [FUNCTIONS][MUTATIVE] ========== */

    /*
	* Pauser
	*/
    function pause() public pauserOnly(msg.sender) whenNotPaused() {
        // Call Pausable "_pause" function
        super._pause();
    }

    function unpause() public pauserOnly(msg.sender) whenPaused() {
        // Call Pausable "_unpause" function
        super._unpause();
    }

    function mint(address _to, uint256 _amount) external
        auth_owner()
        whenNotPaused()
    {
        // Call ERC20Capped "_mint" function
        super._mint(_to, _amount);
    }
}