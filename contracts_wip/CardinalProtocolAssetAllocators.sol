// contracts/AssetAllocator.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


/* ========== [IMPORT] ========== */
// @openzeppelin/contracts/interfaces
import "@openzeppelin/contracts/interfaces/IERC20.sol";
// @openzeppelin/contracts/security
import "@openzeppelin/contracts/security/Pausable.sol";
// @openzeppelin/contracts/token
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
// @openzeppelin/contracts/utils
import "@openzeppelin/contracts/utils/Counters.sol";


/* ========== [IMPORT] ========== */
import "./abstract/CardinalProtocolControl.sol";
import "./abstract/UniswapSwapper.sol";


/// @title Cardinal Protocol Asset Allocators V1 (CPAA)
/// @notice Automated Strategy Allocator Protocol
/// @author harpoonjs.eth
contract CardinalProtocolAssetAllocators is
	ERC721Enumerable,
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


	/* ========== [DEPENDENCY] ========== */
	using Counters for Counters.Counter;


	/* ========== [STRUCT] ========== */
	struct StrategyAllocation {
		uint64 id;
		uint8 pct;
	}

	struct Guideline {
		StrategyAllocation[] strategyAllocations;
	}


	/* ========== [STATE VARIABLE] ========== */
	// Custom Types
	Counters.Counter public _CPAATokenIdTracker;

	string public baseURI;
	address public _treasury;

	// Strategy Id => Whitelisted Strategy
	mapping(uint64 => address) _whitelistedStrategyAddresses;

	// CPAA Id =>
	mapping(uint256 => uint256) _WETHBalanceOf;
	mapping(uint256 => Guideline) _guidelines;


	/* ========== [CONTRUCTOR] ========== */
	constructor (
		address cardinalProtocolAddress_,
		string memory baseURI_,
		address treasury_
	)
		ERC721("Cardinal Protocol Asset Allocators", "CPAA")
		CardinalProtocolControl(cardinalProtocolAddress_)
	{
		baseURI = baseURI_;
		_treasury = treasury_;
	}


	/* ========== [MODIFIER] ========== */
	modifier auth_ownsNFT(uint256 CPAATokenId) {
		// Check if the wallet owns the assetAllocatorId
		require(
			ownerOf(CPAATokenId) == msg.sender,
			"You do not own this AssetAllocator token"
		);

		_;
	}
	
	
	/* ========== [OVERRIDE][FUNCTION] ========== */
	function _burn(uint256 CPAATokenId) internal
		override(ERC721)
		whenNotPaused()
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

		return ERC721._burn(CPAATokenId);
	}


	/* ========== [OVERRIDE][FUNCTION][VIEW] ========== */
	function _baseURI() internal view
		override(ERC721)
		whenNotPaused()
		returns (string memory)
	{
		return baseURI;
	}


	/* ========== [FUNCTION][MUTATIVE] ========== */
	/**
	* ==========================
	* === AUTH LEVEL: _chief ===
	* ==========================
	*/
	/**
	 * @notice Set _baseTokenURI
	 * @param baseURI_ New base URI to be set
	*/
	function setBaseURI(string memory baseURI_) external authLevel_chief() {
		baseURI = baseURI_;
	}

	/**
	 * @notice Pause contract
	*/
	function pause() public
		authLevel_chief()
		whenNotPaused()
	{
		// Call Pausable "_pause" function
		super._pause();
	}

	/**
	 * @notice Unpause contract
	*/
	function unpause() public
		authLevel_chief()
		whenPaused()
	{
		// Call Pausable "_unpause" function
		super._unpause();
	}

	/**
	 * @notice Deposit any ETH sent to this contract to _treasury
	*/
	function withdrawToTreasury() public authLevel_chief() {
		uint balance = address(this).balance;
		
		payable(_treasury).transfer(balance);
	}
	
	/**
	* ==========================
	* === AUTH LEVEL: public ===
	* ==========================
	*/
	function mint(address[] memory toSend, Guideline memory guideline_) public
		whenNotPaused()
	{
		// For each toSend, mint the NFT
		for (uint i = 0; i < toSend.length; i++) {
			// Mint token
			_mint(toSend[i], _CPAATokenIdTracker.current());

			// Create GuideLine for minted token
			_guidelines[_CPAATokenIdTracker.current()] = guideline_;
			
			// [INCREMENT] token id
			_CPAATokenIdTracker.increment();
		}
	}

	/// @notice Deposit WETH into this contract
	function depositWETH(uint256 CPAATokenId, uint256 amount_) public payable
		whenNotPaused()
		auth_ownsNFT(CPAATokenId)
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
	function deployWETHByGuidelines(
		uint256 CPAATokenId,
		uint256[] memory amounts_
	) public
		whenNotPaused()
		auth_ownsNFT(CPAATokenId)
	{
		// Retrieve _guidelines for the token
		Guideline g = _guidelines[CPAATokenId];

		// For each Strategy Allocation
		for (uint i = 0; i < g.strategyAllocations.length; i++) {
			// Calculate amount to convert
			uint256 amountToConvert = g.strategyAllocations[i].pct * _WETHBalanceOf[CPAATokenId];

			// Convert WETH to required tokens 

			// Deposit tokens
			_WETHBalanceOf[CPAATokenId];

			// [EMIT]
			emit DepositedTokensIntoStrategy(
				CPAATokenId,
				_guidelines[CPAATokenId].strategyAllocations[i].id,
				amounts_
			);
		}

		// Reset balance
		_WETHBalanceOf[CPAATokenId] = 0;
	}
}