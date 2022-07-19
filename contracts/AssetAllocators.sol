// contracts/CardinalTreasury.sol
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
	/* ========== [STRUCTS & STATE VARIABLES] ========== */

	struct StrategyAllocation {
		uint id;
		uint pct;
	}

	mapping(int => StrategyAllocation) strategyAllocations;

	struct Guideline {
		uint[] strategyAllocationIds;
	}

	Counters.Counter public _tokenIdTracker;

	address public _assetManagerContract;
	address public _treasury;
	string public _baseTokenURI;

	mapping(uint => Guideline) guidelines;

	/* ========== [CONTRUCTOR] ========== */

	constructor (
		string memory name,
		string memory symbol,
		string memory baseTokenURI,
		address assetManagerContract,
		address treasury
	) ERC721(name, symbol) {
		_baseTokenURI = baseTokenURI;
		_assetManagerContract = assetManagerContract;
		_treasury = treasury;


		_setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
	}
	
    /* ========== [MODIFIERS] ========== */

	modifier mintCompliance(address[] memory toSend) {
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

	function mint(address[] memory toSend) public mintCompliance(toSend) {
		// For each address, mint the NFT
		for (uint i = 0; i < toSend.length; i++) {
			// Mint token
			_mint(toSend[i], _tokenIdTracker.current());
			
			// Increment token id
			_tokenIdTracker.increment();
		}
	}

	// To forward any erc20s from this contract, an array of erc20 token addresses
	// will need to be passed
	function depositTokensIntoStrategies(
		uint assetAllocatorId,
		uint[] amounts
	) {
		// Check if the wallet owns the assetAllocatorId
		require(
			_owners[assetAllocatorId] == msg.sender,
			"You do not own this AssetAllocator token"
		);

		// Retrieve guideline
		Guideline g = guidelines[assetAllocatorId];

		// For each strategyAllocationId
		for (uint256 i = 0; i < g.strategyAllocationIds.length; i++) {
			uint sId = g.strategyAllocationIds[i];

			// Get strategie allocation
			uint s = strategyAllocations[sId];


		}
	}

    /* ========== [FUNCTION][OTHER] ========== */

	function withdrawToTreasury() public onlyOwner {
		uint balance = address(this).balance;
		
		payable(_treasury).transfer(balance);
	}
}
