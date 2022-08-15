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


/// @title Cardinal Protocol Asset Allocators V1 (CPAA)
/// @notice Automated Strategy Allocator Protocol
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

	mapping(uint256 => uint256) _WETHBalanceOf;


	/* ========== [CONTRUCTOR] ========== */
	constructor (address cardinalProtocolAddress_)
		CardinalProtocolControl(cardinalProtocolAddress_)
	{}


	/* ========== [MODIFIER] ========== */
	modifier auth_ownsCPAA(uint256 CPAATokenId) {
		// Check if the wallet owns the assetAllocatorId
		require(
			IERC721(CPAA).ownerOf(CPAATokenId) == msg.sender,
			"You do not own this AssetAllocator token"
		);

		_;
	}


	/// @notice Deposit WETH into this contract
	function depositWETH(uint256 CPAATokenId, uint256 amount_) public payable
		whenNotPaused()
		auth_ownsCPAA(CPAATokenId)
	{
		// [IERC20] Transfer WETH from caller to this contract
		IERC20(WETH).transferFrom(
			msg.sender,
			address(this),
			amount_
		);

		// [ADD] _WETHBalanceOf
		_WETHBalanceOf[CPAATokenId] = _WETHBalanceOf[CPAATokenId] + amount_;

		// [EMIT]
		emit DepositedWETH(CPAATokenId, amount_);
	}

	/// @notice Deposit WETH into strategies following guidelines 
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
		_WETHBalanceOf[CPAATokenId] = 0;
	}

	function cashOut(CPAATokenId) public
		auth_ownsCPAA(CPAATokenId)
	{
		// Distribute the tokens that are being yield farmed
		for (uint256 i = 0; i < _guidelines[CPAATokenId].strategyAllocations.length; i++) {
			// Withdraw tokens

			// [EMIT]
			emit WithdrewTokensFromStrategy(
				CPAATokenId,
				_guidelines[CPAATokenId].strategyAllocations[i].id
			);
		}
	}

	function unnamed(CPAATokenId) public
		auth_ownsCPAA(CPAATokenId)
	{
		// _guidelines NOT existent 
		if (!_guidelines[CPAATokenId]) {
			// Create _guidelines
			_guidelines[_CPAATokenIdTracker.current()] = guideline_;
		}
	}
}