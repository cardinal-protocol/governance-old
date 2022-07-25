// contracts/Strategy.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;


interface CardinalProtocol {
	function owner() external view returns (address);
}

abstract contract Strategy {
	/* ========== [STRUCTS] ========== */
	
	struct Deposite {
		uint64 assetAllocatorTokenId;
		address[] amounts;
	}

	struct WithdrawalRequest {
		uint64 assetAllocatorTokenId;
		address[] amounts;
	}


	/* ========== [STATE-VARIABLES][CONST] ========== */

	address public CARDINAL_PROTOCOL_ADDRESS;
	address public CARDINAL_PROTOCOL_ASSET_ALLOCATORS_ADDRESS;


	/* ========== [STATE-VARIABLES][AUTH] ========== */

	address public _keeper;


	/* ========== [STATE-VARIABLES] ========== */
	
	string public _name;

	address[] public _tokensUsed;

	bool public _active = false;

	Deposite[] _deposits;
	WithdrawalRequest[] _withdrawalRequests;

	mapping(address => uint64) _deployedBalances;


	/* ========== [CONSTRUCTOR] ========== */

	constructor (
		address cardinalProtocolAddress,
		address cardinalProtocolAssetAllocatorsAddress,
		address keeper_,
		string memory name_,
		address[] memory tokensUsed_
	) {
		CARDINAL_PROTOCOL_ADDRESS = cardinalProtocolAddress;
		CARDINAL_PROTOCOL_ASSET_ALLOCATORS_ADDRESS = cardinalProtocolAssetAllocatorsAddress;

		_keeper = keeper_;

		_name = name_;
		_tokensUsed = tokensUsed_;

	}


	/* ========== [MODIFIERS] ========== */

	modifier auth_owner() {
		// Require that the caller can only by the AssetAllocators Contract
		require(
			msg.sender == CardinalProtocol(CARDINAL_PROTOCOL_ADDRESS).owner(),
			"!auth"
		);

		_;
	}

	modifier auth_adminOrKepper() {
		// Require that the caller can only by the AssetAllocators Contract
		require(
			msg.sender == _keeper ||
			msg.sender == CardinalProtocol(CARDINAL_PROTOCOL_ADDRESS).owner(),
			"!auth"
		);

		_;
	}

	modifier auth_assetAllocator() {
		// Require that the caller can only by the AssetAllocators Contract
		require(msg.sender == CARDINAL_PROTOCOL_ASSET_ALLOCATORS_ADDRESS, "!auth");

		_;
	}

	modifier active() {
		require(_active, "Strategy is not active");

		_;
	}


	/* ========== [FUNCTIONS][MUTATIVE] ========== */

	/*
	* Owner
	*/
	function set_keeper(address keeper_) public auth_owner() {
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
	function create_deposits(
		uint64 assetAllocatorTokenId,
		uint64[] memory amounts
	) external
		virtual
		auth_assetAllocator()
		active()
	{
		// Create a deposit
	}

	function create_withdrawalRequests(
		uint64 assetAllocatorTokenId,
		uint64[] memory amounts
	) external
		auth_assetAllocator()
	{
		// Create a withdrawl Request
	}


	/* ========== [FUNCTIONS][NON-MUTATIVE] ========== */

	function tokensUsed() public view
		virtual
		returns (address[] memory)
	{
		return _tokensUsed;
	}
}