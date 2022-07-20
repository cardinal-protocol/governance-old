// contracts/StrategyX.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract StrategyX {
	/* ========== [STATE-VARIABLES][IMMUTABLE] ========== */

	string public _name;


	/* ========== [STATE-VARIABLES][AUTH] ========== */

	address public _admin;
	address public _keeper;

	address public _assetAllocators;


	/* ========== [STATE-VARIABLES] ========== */
	
	bool public active = false;

	address[] public _tokensUsed;

	mapping(address => uint) balanceOf;

	/* ========== [CONSTRUCTOR] ========== */

	constructor (
		string memory name,
		address admin,
		address keeper
	) {
		_name = name;
		_admin = admin;
		_keeper = keeper;
	}


	/* ========== [MODIFIERS] ========== */

	modifier auth_admin() {
		// Require that the caller can only by the AssetAllocators Contract
		require(msg.sender == _admin, "!auth");

		_;
	}

	modifier auth_keeper() {
		// Require that the caller can only by the AssetAllocators Contract
		require(msg.sender == _keeper || msg.sender == _admin, "!auth");

		_;
	}

	modifier only_assetAllocator() {
		// Require that the caller can only by the AssetAllocators Contract
		require(msg.sender == _assetAllocators, "!auth");

		_;
	}

	modifier isActive() {
		require(active, "Strategy is not active");

		_;
	}


	/* ========== [FUNCTIONS][MUTATIVE] ========== */

	function set_admin(address admin) public auth_admin() {
		// Bestow the honor..
		_admin = admin;
	}

	function set_assetAllocator(address assetAllocators) public auth_admin() {
		// Bestow the honor..
		_assetAllocators = assetAllocators;
	}

	function set_keeper(address keeper) public auth_admin() {
		// Bestow the honor..
		_keeper = keeper;
	}

	function toggleIsActive() public auth_keeper() {
		active = !active;
	}

	function updateDeposits(address behalfOf, uint[] memory _amounts) public
		only_assetAllocator()
		isActive()
	{
		// This is where the tokens are deposited into the external DeFi Protocol.
	}


	/* ========== [FUNCTIONS][NON-MUTATIVE] ========== */

	function tokensUsed() public view returns (address[] memory) {
		return _tokensUsed;
	}
}