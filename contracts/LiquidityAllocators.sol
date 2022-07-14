// contracts/CardinalTreasury.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract LiquidityAllocators {

	/* ========== STRUCTS ========== */

	struct LiquidityAllocator {
		string whitelistedLPTokens;
		mapping(string => int) allocations;
	}

	/* ========== STATE VARIABLES ========== */
	
	mapping(int => string) whitelistedLPTokens;

	mapping(int => LiquidityAllocator) liqiidityAllocators;

    /* ========== MODIFIERS ========== */
	
	// Check if caller is the owner of the liquidity allocator
}