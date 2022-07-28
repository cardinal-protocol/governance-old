// contracts/CardinalProtocolToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


/* ========== [IMPORT][PERSONAL] ========== */
import "../interface/ICardinalProtocol.sol";


abstract contract CardinalProtocolController {
	/* ========== [EVENTS] ========== */
	event NewCardinalProtocolAddress(
		address oldAddress,
		address newAddress
	);


	/* ========== [STATE VARIABLES] ========== */
	address public _cardinalProtocolAddress;


	/* ========== [CONSTRUCTOR] ========== */
	constructor (address cardinalProtocolAddress_) {
		_cardinalProtocolAddress = cardinalProtocolAddress_;
	}


	/* ========== [MODIFIERS] ========== */
	modifier authLevel_admin() {
		require(
			ICardinalProtocol(_cardinalProtocolAddress).authLevel_admin(msg.sender),
			"!auth"
		);

		_;
	}

	modifier authLevel_chief() {
		require(
			ICardinalProtocol(_cardinalProtocolAddress).authLevel_chief(msg.sender),
			"!auth"
		);

		_;
	}

	modifier authLevel_executive() {
		require(
			ICardinalProtocol(_cardinalProtocolAddress).authLevel_executive(msg.sender),
			"!auth"
		);

		_;
	}

	modifier authLevel_manager() {
		require(
			ICardinalProtocol(_cardinalProtocolAddress).authLevel_manager(msg.sender),
			"!auth"
		);

		_;
	}


	/* ========== [FUNCTIONS][MUTATIVE] ========== */
	/*
	* Auth Level: _chief 
	*/
	function set_cardinalProtocolAddress(address cardinalProtocolAddress_) public
		authLevel_chief()
	{
		emit NewCardinalProtocolAddress(
			_cardinalProtocolAddress,
			cardinalProtocolAddress_
		);

		_cardinalProtocolAddress = cardinalProtocolAddress_;
	}
}