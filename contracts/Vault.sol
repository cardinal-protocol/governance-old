// contracts/CardinalTreasury.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Vault {
	/* ========== STATE VARIABLES ========== */
	
	mapping(uint => bool) public active;

    /* ========== MUTATIVE FUNCTIONS ========== */
	
	function deposit(uint strategyId, uint256 _amount) public {
		require(active[strategyId], "Strategy is not active");

		
	}
}