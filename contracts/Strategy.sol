// contracts/CardinalTreasury.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Vault {
	/* ========== STATE VARIABLES ========== */
	
	mapping(uint => bool) public active;

    /* ========== MODIFIERS ========== */

	modifier isNotShutDown(uint strategyId) {
		require(active[strategyId], "Strategy is not active");

		_;
	}

    /* ========== MUTATIVE FUNCTIONS ========== */
	
	function deposit(
		uint strategyId,
		uint _amount
	) public isNotShutDown(strategyId) {
		
	}
}