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

	// Balances deposited 
	mapping (uint256 => uint256[]) public _deposits;
	
	mapping (uint256 => uint256) public _deployedBalances;
	mapping (uint256 => uint256) public _withdrawRequests;


	/* ========== [CONSTRUCTOR] ========== */
	constructor (
		address cardinalProtocolControl_,
		address _CPAA,
		string memory name_,
		address[] memory acceptedTokens_
	) CardinalProtocolControl(cardinalProtocolControl_) {
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

	/**
     * @notice
     *  Provide an accurate estimate for the total amount of assets
     *  (principle + return) that this Strategy is currently managing,
     *  denominated in terms of `want` tokens.
     *
     *  This total should be "realizable" e.g. the total value that could
     *  *actually* be obtained from this Strategy if it were to divest its
     *  entire position based on current on-chain conditions.
     * @dev
     *  Care must be taken in using this function, since it relies on external
     *  systems, which could be manipulated by the attacker to give an inflated
     *  (or reduced) value produced by this function, based on current on-chain
     *  conditions (e.g. this function is possible to influence through
     *  flashloan attacks, oracle manipulations, or other DeFi attack
     *  mechanisms).
     *
     *  It is up to governance to use this function to correctly order this
     *  Strategy relative to its peers in the withdrawal queue to minimize
     *  losses for the Vault based on sudden withdrawals. This value should be
     *  higher than the total debt of the Strategy and higher than its expected
     *  value to be "safe".
     * @return The estimated total assets in this Strategy.
	*/
    function estimatedTotalAssets() public view virtual returns (uint256);
}