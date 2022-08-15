// contracts/AssetAllocator.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


/* ========== [IMPORT] ========== */
// @openzeppelin/contracts/interfaces
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/interfaces/IERC721.sol";
// @openzeppelin/contracts/security
import "@openzeppelin/contracts/security/Pausable.sol";


/* ========== [IMPORT-PERSONAL] ========== */
import "./abstract/CardinalProtocolControl.sol";
import "./abstract/UniswapSwapper.sol";


/// @title Cardinal Protocol Asset Allocators (CPAA)
/// @notice Asset Management Protocol
/// @author harpoonjs.eth
contract AssetAllocations is
	Pausable,
	CardinalProtocolControl,
	UniswapSwapper
{
	/* ========== [EVENT] ========== */
	event DepositedWETH(
		uint256 CPAATokenId,
		uint256 amount
	);

	event WithdrewWETH(
		uint256 CPAATokenId,
		uint256 amount
	);

	event DepositedTokensIntoStrategy(
		uint256 CPAATokenId,
		uint64 strategy,
		uint256[] amounts
	);

	event WithdrewTokensFromStrategy(
		uint256 CPAATokenId,
		uint64 strategy
	);


	/* ========== [STATE VARIABLE] ========== */
	mapping(uint64 => address) _whitelistedStrategyAddresses;

	mapping(uint256 => uint256) _WETHBalances;


	/* ========== [CONTRUCTOR] ========== */
	constructor (address cardinalProtocolAddress_)
		CardinalProtocolControl(cardinalProtocolAddress_)
	{}


	/* ========== [MODIFIER] ========== */
	/// @notice Check if msg.sender owns the CPAA
	/// @param CPAATokenId CPAA Token Id
	modifier auth_ownsCPAA(uint256 CPAATokenId) {
		// Check if the wallet owns the assetAllocatorId
		require(
			IERC721(CPAA).ownerOf(CPAATokenId) == msg.sender,
			"You do not own this AssetAllocator token"
		);

		_;
	}


	/* ========== [FUNCTION] ========== */
	/// @notice Deposit WETH into this contract
	/// @param CPAATokenId CPAA Token Id
	/// @param amount Amount that is to be deposited
	function depositWETH(uint256 CPAATokenId, uint256 amount) public payable
		whenNotPaused()
		auth_ownsCPAA(CPAATokenId)
	{
		// [IERC20] Transfer WETH from caller to this contract
		IERC20(WETH).transferFrom(
			msg.sender,
			address(this),
			amount
		);

		// [ADD] _WETHBalances
		_WETHBalances[CPAATokenId] = _WETHBalances[CPAATokenId] + amount;

		// [EMIT]
		emit DepositedWETH(CPAATokenId, amount);
	}

	/// @notice Withdraw WETH
	/// @param CPAATokenId CPAA Token Id
	/// @param amount Amount that is to be withdrawn
	function withdrawWETH(uint256 CPAATokenId, uint256 amount) public payable {
		require(_WETHBalances[CPAATokenId] >= amount, "You do not have enough WETH");

		IERC20(WETH).transferFrom(
			address(this),
			msg.sender,
			amount
		);

		// [SUBTRACT] _WETHBalances
		_WETHBalances[CPAATokenId] = _WETHBalances[CPAATokenId] - amount;

		// [EMIT]
		emit WithdrewWETH(CPAATokenId, amount);
	}

	/// @notice Withdraw All WETH
	/// @param CPAATokenId CPAA Token Id
	function withdrawAllWETH(uint256 CPAATokenId) public payable {
		IERC20(WETH).transferFrom(
			address(this),
			msg.sender,
			_WETHBalances[CPAATokenId]
		);

		// [SUBTRACT] _WETHBalances
		_WETHBalances[CPAATokenId] = 0;
	}

	/// @notice Deposit WETH into strategies following guidelines 
	/// @param CPAATokenId CPAA Token Id
	function deployWETHToStrategy(
		uint256 CPAATokenId,
		uint64 strategyId
	) public
		whenNotPaused()
		auth_ownsCPAA(CPAATokenId)
	{
		// Emit
		emit DepositedTokensIntoStrategy(
			CPAATokenId,
			strategyId,
			amounts_
		);

		// Reset balance
		_WETHBalances[CPAATokenId] = 0;
	}

	/// @param CPAATokenId CPAA Token Id
	function withdrawTokensFromStrategies(CPAATokenId) public
		auth_ownsCPAA(CPAATokenId)
	{}
}