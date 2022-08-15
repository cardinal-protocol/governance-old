// contracts/example/Strategy.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;


/* ========== [IMPORT][PERSONAl] ========== */
import "../abstract/CardinalProtocolControl.sol";


abstract contract Strategy is CardinalProtocolControl {
	/* ========== [STRUCTS] ========== */
	struct Deposit {
		uint64 CPAATokenId;
		address[] amounts;
	}

	struct WithdrawalRequest {
		uint64 CPAATokenId;
		address[] amounts;
	}


	/* ========== [STATE-VARIABLES] ========== */
	address public CPAA;
	address public _keeper;
	string public _name;
	bool public _active = false;
	address[] public _tokensRequired;
	Deposit[] _deposits;
	WithdrawalRequest[] _withdrawalRequests;
	mapping(address => uint64) _deployedBalances;


	/* ========== [CONSTRUCTOR] ========== */
	constructor (
		address _CPAA,
		string memory name_,
		address[] memory tokensUsed_
	) {
		CPAA = _CPAA;
		_name = name_;
		_tokensRequired = tokensUsed_;
	}

	/* ========== [MODIFIERS] ========== */
	modifier authLevel_keeper() {
		require(
			ICardinalProtocol(_cardinalProtocolAddress).authLevel_manager(msg.sender) ||
			_keeper == msg.sender,
			"!auth"
		);

		_;
	}

	modifier auth_assetAllocator() {
		require(CPAA == msg.sender, "!auth");

		_;
	}

	modifier active() {
		require(_active, "Strategy is not active");

		_;
	}


	/* ========== [FUNCTIONS][MUTATIVE] ========== */
	/*
	* Auth Level: _manager
	*/
	function set_keeper(address keeper_) public authLevel_manager() {
		_keeper = keeper_;
	}

	/*
	* Auth Level: _keeper
	*/
	function set_name(string memory name_) public
		virtual
		authLevel_keeper()
	{
		_name = name_;
	}

	function set_tokensRequired(address[] memory tokensUsed_) public
		virtual
		authLevel_keeper()
	{
		_tokensRequired = tokensUsed_;
	}

	function toggleActive() public
		virtual
		authLevel_keeper()
	{
		_active = !_active;
	}

	/*
	* Auth: _cardinalProtocolAssetAllocatorsAddress
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

	function tokensRequired() public view virtual returns (address[] memory) {
		return _tokensRequired;
	}
}