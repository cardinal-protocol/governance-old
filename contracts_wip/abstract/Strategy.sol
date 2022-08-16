// contracts/example/Strategy.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


/* ========== [IMPORT][PERSONAL] ========== */
import "./CardinalProtocolControl.sol";


abstract contract Strategy is CardinalProtocolControl {
	/* ========== [STATE-VARIABLE] ========== */
	address public CPAA;
	
	address public _keeper;
	
	string public _name;

	bool public _active = false;
	
	address[] public _acceptedTokens;

	// CPAA => { Accepted Token Addresse => Deposit Balance }
	mapping (uint256 => mapping (address => uint256)) _deposits;
	
	mapping (uint256 => uint256) _deployedBalances;
	mapping (uint256 => uint256) _withdrawRequests;


	/* ========== [CONSTRUCTOR] ========== */
	constructor (
		address _CPAA,
		string memory name_,
		address[] memory acceptedTokens_
	) {
		CPAA = _CPAA;
		_name = name_;
		_acceptedTokens = acceptedTokens_;
	}

	/* ========== [MODIFIER] ========== */
	/// @notice Auth Level _keeper
	modifier authLevel_keeper() {
		require(
			ICardinalProtocol(_cardinalProtocolAddress).authLevel_manager(msg.sender)
			||
			_keeper == msg.sender,
			"!auth"
		);

		_;
	}

	/// @notice Auth CPAA
	modifier authCPAA() {
		require(CPAA == msg.sender, "!auth");

		_;
	}

	/// @notice Must be active
	modifier active() {
		require(_active, "Strategy is not active");

		_;
	}


	/* ========== [FUNCTION][MUTATIVE] ========== */
	/**
	* ==========================
	* === AUTH LEVEL: _admin ===
	* ==========================
	*/
	/// @notice Set name of strategy
	/// @param name_ New name to be assigned
	function set_name(string memory name_) public
		virtual
		authLevel_admin()
	{
		_name = name_;
	}

	/// @notice Set acceptedTokens
	/// @param acceptedTokens_ New name to be assigned
	function set_acceptedTokens(address[] memory acceptedTokens_) public
		virtual
		authLevel_admin()
	{
		_acceptedTokens = acceptedTokens_;
	}

	/**
	* ============================
	* === AUTH LEVEL: _manager ===
	* ============================
	*/
	function set_keeper(address keeper_) public authLevel_manager() {
		_keeper = keeper_;
	}

	/**
	* ===========================
	* === AUTH LEVEL: _keeper ===
	* ===========================
	*/
	/// @notice Toggle active
	function toggleActive() public
		virtual
		authLevel_keeper()
	{
		_active = !_active;
	}

	/**
	* ==================
	* === AUTH: CPAA ===
	* ==================
	*/
	/// @notice
	function create_deposits(
		uint64 CPAATokenId,
		uint64[] memory amounts
	) external
		virtual
		authCPAA()
		active()
	{
		// Create a deposit
	}

	/// @notice
	function create_withdrawalRequests(
		uint64 CPAATokenId,
		uint64[] memory amounts
	) external
		authCPAA()
	{
		// Create a withdrawl Request
	}


	/* ========== [FUNCTION][NON-MUTATIVE] ========== */
	/// @notice Return tokens required
	function acceptedTokens() public view virtual returns (address[] memory) {
		return _acceptedTokens;
	}
}