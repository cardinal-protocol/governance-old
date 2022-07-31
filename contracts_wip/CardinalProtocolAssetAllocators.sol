// contracts/AssetAllocator.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


/* ========== [IMPORT] ========== */
// @openzeppelin/contracts/interfaces
import "@openzeppelin/contracts/interfaces/IERC20.sol";
// @openzeppelin/contracts/token
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
// @openzeppelin/contracts/utils
import "@openzeppelin/contracts/utils/Counters.sol";


/* ========== [IMPORT] ========== */
import "./abstract/CardinalProtocolControl.sol";


contract CardinalProtocolAssetAllocators is
	ERC721Enumerable,
	CardinalProtocolControl
{
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
	

	/* ========== [STATE VARIABLE][CONSTANT] ========== */
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;


	/* ========== [STATE VARIABLE] ========== */
	// Custom Types
	Counters.Counter public _CPAATokenIdTracker;

	string public _baseTokenURI;
	address public _treasury;

	// Strategy Id => Whitelisted Strategy
	mapping(uint64 => address) _whitelistedStrategyAddresses;

	// CPAA Id =>
	mapping(uint256 => uint256) _WETHBalanceOf;
	mapping(uint256 => Guideline) _guidelines;


	/* ========== [EVENT] ========== */
	event DepositedEther(
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


	/* ========== [CONTRUCTOR] ========== */
	constructor (
		address cardinalProtocolAddress_,
		string memory baseTokenURI_,
		address treasury_
	)
		ERC721("Cardinal Protocol Asset Allocators", "CPAA")
		CardinalProtocolControl(cardinalProtocolAddress_)
	{
		_baseTokenURI = baseTokenURI_;
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
	
	
	/* ========== [OVERRIDE][FUNCTION][REQUIRED] ========== */
	function _burn(uint256 CPAATokenId) internal virtual override(ERC721) {
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

	// Return the full URI of a token
	function tokenURI(uint256 CPAATokenId) public view
		override(ERC721)
		returns (string memory)
	{
		return ERC721.tokenURI(CPAATokenId);
	}


	/* ========== [OVERRIDE][FUNCTION][VIEW] ========== */
	function _baseURI() internal view virtual override returns (string memory) {
		return _baseTokenURI;
	}


	/* ========== [FUNCTION][SELF-IMPLEMENTATION] ========== */
	function setBaseURI(string memory baseTokenURI) external authLevel_chief() {
		_baseTokenURI = baseTokenURI;
	}


	/* ========== [FUNCTION][MUTATIVE] ========== */
	function mint(address[] memory toSend, Guideline memory guideline_) public {
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
		auth_ownsNFT(CPAATokenId)
	{
		IERC20(WETH).transferFrom(
			msg.sender,
			address(this),
			amount_
		);

		// Increment _WETHBalanceOf
		_WETHBalanceOf[CPAATokenId] = _WETHBalanceOf[CPAATokenId] + amount_;

		// [EMIT]
		emit DepositedEther(CPAATokenId, amount_);
	}

	function depositTokensIntoStrategies(
		uint256 CPAATokenId,
		uint256[] memory amounts_
	) public
		auth_ownsNFT(CPAATokenId)
	{
		// For each Strategy Allocation
		for (
			uint i = 0;
			i < _guidelines[CPAATokenId].strategyAllocations.length;
			i++
		) {
			// Deposit tokens
			
			// [EMIT]
			emit DepositedTokensIntoStrategy(
				CPAATokenId,
				_guidelines[CPAATokenId].strategyAllocations[i].id,
				amounts_
			);
		}
	}


	/* ========== [FUNCTION][OTHER] ========== */
	function withdrawToTreasury() public authLevel_chief() {
		uint balance = address(this).balance;
		
		payable(_treasury).transfer(balance);
	}
}