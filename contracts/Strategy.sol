// contracts/Strategy.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Strategy {
	/* ========== [STATE-VARIABLES][AUTH] ========== */

	address public _admin;
	address public _keeper;
	address public _assetAllocators;


	/* ========== [STATE-VARIABLES] ========== */
	
	string public _name;

	address[] public _tokensUsed;

	bool public _active = false;

	mapping(address => uint) _depositedBalances;
	mapping(address => uint) _deployedBalances;


	/* ========== [CONSTRUCTOR] ========== */

	constructor (
		address admin_,
		address keeper_,
		string memory name_,
		address[] memory tokensUsed_
	) {
		_admin = admin_;
		_keeper = keeper_;

		_name = name_;
		_tokensUsed = tokensUsed_;

	}


	/* ========== [MODIFIERS] ========== */

	modifier auth_admin() {
		// Require that the caller can only by the AssetAllocators Contract
		require(msg.sender == _admin, "!auth");

		_;
	}

	modifier auth_adminOrKepper() {
		// Require that the caller can only by the AssetAllocators Contract
		require(msg.sender == _keeper || msg.sender == _admin, "!auth");

		_;
	}

	modifier auth_assetAllocator() {
		// Require that the caller can only by the AssetAllocators Contract
		require(msg.sender == _assetAllocators, "!auth");

		_;
	}

	modifier active() {
		require(_active, "Strategy is not active");

		_;
	}


	/* ========== [FUNCTIONS][MUTATIVE] ========== */

	/*
	* Admin
	*/
	function set_admin(address admin_) public auth_admin() {
		_admin = admin_;
	}

	function set_assetAllocator(address assetAllocators_) public auth_admin() {
		_assetAllocators = assetAllocators_;
	}

	function set_keeper(address keeper_) public auth_admin() {
		_keeper = keeper_;
	}

	/*
	* Admin || Keeper
	*/
	function set_name(string memory name_) public
		virtual
		auth_adminOrKepper()
	{
		_name = name_;
	}

	function set_tokensUsed(address[] memory tokensUsed_) public
		virtual
		auth_adminOrKepper()
	{
		_tokensUsed = tokensUsed_;
	}

	function toggleActive() public
		virtual
		auth_adminOrKepper()
	{
		_active = !_active;
	}

	/*
	* Asset Allocator
	*/
	function update_depositedBalances(address behalfOf, uint[] memory amounts) public
		virtual
		auth_assetAllocator()
		active()
	{
		// This is where the tokens are deposited into the external DeFi Protocol.
	}


	/* ========== [FUNCTIONS][NON-MUTATIVE] ========== */

	function tokensUsed() public view
		virtual
		returns (address[] memory)
	{
		return _tokensUsed;
	}
}