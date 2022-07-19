// contracts/CardinalTreasury.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Strategy1 {
	/* ========== IMMUTABLE STATE VARIABLES ========== */

	address AssetAllocators;

	/* ========== STATE VARIABLES ========== */
	
	string _name = 'UNISWAP V2 DAI-USDC';

	bool active = false;
	
	address[] _tokensUsed = [
		0x6B175474E89094C44Da98b954EedeAC495271d0F,
		0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
	];

    /* ========== MODIFIERS ========== */

	modifier authorized() {
		// Require that the caller can only by the AssetAllocators Contract
		require(msg.sender == AssetAllocators, "!auth");

		_;
	}

	modifier isActive() {
		require(active, "Strategy is not active");

		_;
	}

    /* ========== MUTATIVE FUNCTIONS ========== */
	
	function deposit(address behalfOf, uint[] memory _amounts) public authorized() isActive() {
		// This is where the tokens are deposited into the external DeFi Protocol.
		
	}

    /* ========== VIEW FUNCTIONS ========== */
	
	function tokensUsed() public view returns (address[] memory) {
        return _tokensUsed;
    }
}