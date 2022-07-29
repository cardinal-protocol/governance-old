// contracts/AssetAllocator.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


/* ========== [IMPORT] ========== */
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


	/* ========== [STATE VARIABLE] ========== */
	// Custom Types
	Counters.Counter public _tokenIdTracker;

	string public _baseTokenURI;
	address public _treasury;

	mapping(uint64 => address) _whitelistedStrategyAddresses;
	mapping(uint256 => Guideline) _guidelines;


	/* ========== [EVENT] ========== */
	event DepositedTokensIntoStrategy(
		uint64 strategy,
		uint256[] amounts
	);

	event WithdrewTokensFromStrategy(
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
	modifier auth_ownsNFT(uint256 AssetAllocatorTokenId) {
		// Check if the wallet owns the assetAllocatorId
		require(
			ownerOf(AssetAllocatorTokenId) == msg.sender,
			"You do not own this AssetAllocator token"
		);

		_;
	}
	
	
	/* ========== [OVERRIDE][FUNCTION][REQUIRED] ========== */
	function _burn(uint256 tokenId) internal virtual override(ERC721) {
		// Distribute the tokens that are being yield farmed

		for (uint256 i = 0; i < _guidelines[tokenId].strategyAllocations.length; i++) {
			// Withdraw tokens

			// [EMIT]
			emit WithdrewTokensFromStrategy(
				_guidelines[tokenId].strategyAllocations[i].id
			);
		}

		return ERC721._burn(tokenId);
	}

	// Return the full URI of a token
	function tokenURI(uint256 tokenId) public view
		override(ERC721)
		returns (string memory)
	{
		return ERC721.tokenURI(tokenId);
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
	function mint(
		address[] memory toSend,
		Guideline memory guideline_
	) public {
		// For each toSend, mint the NFT
		for (uint i = 0; i < toSend.length; i++) {
			// Mint token
			_mint(toSend[i], _tokenIdTracker.current());

			// Create GuideLine for minted token
			_guidelines[_tokenIdTracker.current()] = guideline_;
			
			// [INCREMENT] token id
			_tokenIdTracker.increment();
		}
	}

	
	function depositTokensIntoStrategies(
		uint256 tokenId,
		uint256[] memory amounts_
	) public
		auth_ownsNFT(tokenId)
	{
		// For each Strategy Allocation
		for (uint i = 0; i < _guidelines[tokenId].strategyAllocations.length; i++) {
			// Deposit tokens
			
			// [EMIT]
			emit DepositedTokensIntoStrategy(
				_guidelines[tokenId].strategyAllocations[i].id,
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