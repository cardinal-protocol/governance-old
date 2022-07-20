// contracts/AssetAllocator.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


/* ========== [IMPORT] ========== */

// access
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
// token
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
// utils
import "@openzeppelin/contracts/utils/Counters.sol";


contract AssetAllocators is
	AccessControlEnumerable,
	ERC721Enumerable,
	Ownable
{
	/* ========== [STRUCTS] ========== */

	struct StrategyAllocation {
		uint64 id;
		uint64 pct;
	}

	struct Guideline {
		StrategyAllocation[] strategyAllocations;
	}

	/* ========== [STATE VARIABLES] ========== */

	// Custom Types
	Counters.Counter public _tokenIdTracker;

	string public _baseTokenURI;
	address public _treasury;

	mapping(uint64 => address) _whitelistedStrategyAddresses;
	mapping(uint64 => Guideline) _guidelines;


	/* ========== [CONTRUCTOR] ========== */

	constructor (
		string memory baseTokenURI,
		address treasury
	) ERC721("Asset Allocators", "ASSTALLCTR") {
		_baseTokenURI = baseTokenURI;
		_treasury = treasury;

		_setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
	}

	
	/* ========== [MODIFIERS] ========== */

	modifier mintCompliance() {
		_;
	}


	/* ========== [FUNCTION][OVERRIDE][REQUIRED] ========== */
	
	function _burn(uint256 tokenId) internal virtual override(ERC721) {
		
		// Distribute the tokens that are being yield farmed

		return ERC721._burn(tokenId);
	}

	// Return the full IPFS URI of a token
	function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
		return ERC721.tokenURI(tokenId);
	}

	function _beforeTokenTransfer(
		address from,
		address to,
		uint256 tokenId
	) internal virtual override {
		super._beforeTokenTransfer(from, to, tokenId);
	}

	function supportsInterface(bytes4 interfaceId) public view virtual override(
		AccessControlEnumerable,
		ERC721Enumerable
	) returns (bool) {
		return super.supportsInterface(interfaceId);
	}


	/* ========== [FUNCTION][OVERRIDE] ========== */

	function _baseURI() internal view virtual override returns (string memory) {
		return _baseTokenURI;
	}


	/* ========== [FUNCTION][SELF-IMPLEMENTATIONS] ========== */

	function setBaseURI(string memory baseTokenURI) external onlyOwner {
		_baseTokenURI = baseTokenURI;
	}


	/* ========== [FUNCTION] ========== */

	function mint(
		address[] memory toSend,
		Guideline guideline
	) public
		mintCompliance()
	{
		// For each toSend, mint the NFT
		for (uint i = 0; i < toSend.length; i++) {
			// Mint token
			_mint(toSend[i], _tokenIdTracker.current());

			// Add Guideline
			_guidelines[_tokenIdTracker.current()] = guideline;
			
			// Increment token id
			_tokenIdTracker.increment();
		}
	}

	// To forward any erc20s from this contract, an array of erc20 token addresses
	// will need to be passed
	function depositTokensIntoStrategies(
		uint AssetAllocatorTokenId,
		uint[] amounts
	) public {
		// Check if the wallet owns the assetAllocatorId
		require(
			_owners[AssetAllocatorTokenId] == msg.sender,
			"You do not own this AssetAllocator token"
		);

		// Retrieve Guideline
		Guideline tokenGuideLine = guidelines[AssetAllocatorTokenId];

		// For each Strategy Allocation
		for (uint i = 0; i < tokenGuideLine.strategyAllocations.length; i++) {
			
		}
	}


	/* ========== [FUNCTION][OTHER] ========== */

	function withdrawToTreasury() public onlyOwner {
		uint balance = address(this).balance;
		
		payable(_treasury).transfer(balance);
	}
}