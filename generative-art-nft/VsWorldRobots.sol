// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


/* [IMPORT] */
// access
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
// token
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// utils
import "@openzeppelin/contracts/utils/escrow/Escrow.sol";
import "@openzeppelin/contracts/utils/Counters.sol";



/* [MAIN-CONTRACT] */
contract VsWorldRobots is
	AccessControlEnumerable,
	ERC721Enumerable,
	ERC721URIStorage,
	Escrow
{
	// using for
	using Counters for Counters.Counter;


	// init
	address _treasury;
	bool _openMint = false;	
	string private _baseTokenURI;
	uint private _mintPrice;


	// init - const
	string public ROBOTS_VS_ALIENS_ROBOTS_PROVENANCE = "";
	uint256 public MAX_ROBOTS;


	// init - Custom Data Types
	Counters.Counter public _tokenIdTracker;


	/* [CONSTRUCTOR] */
	constructor (
		string memory name,
		string memory symbol,
		uint max,
		string memory baseTokenURI,
		uint mintPrice,
		address treasury,
		address admin
	) ERC721(name, symbol) {
		MAX_ROBOTS = max;

		_baseTokenURI = baseTokenURI;
		_mintPrice = mintPrice;
		_treasury = treasury;
		
		_setupRole(DEFAULT_ADMIN_ROLE, treasury);
		_setupRole(DEFAULT_ADMIN_ROLE, admin);
	}


	/* [FUNCTIONS][OVERRIDE][REQUIRED] */
	function _burn(uint256 tokenId) internal virtual override(ERC721, ERC721URIStorage) {
		return ERC721URIStorage._burn(tokenId);
	}

	function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
		return ERC721URIStorage.tokenURI(tokenId);
	}

	function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(ERC721, ERC721Enumerable) {
		super._beforeTokenTransfer(from, to, tokenId);
	}

	function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControlEnumerable, ERC721, ERC721Enumerable) returns (bool) {
		return super.supportsInterface(interfaceId);
	}


	/* [FUNCTIONS][OVERRIDE] */
	function _baseURI() internal view virtual override returns (string memory) {
		return _baseTokenURI;
	}


	/* [FUNCTIONS][SELF-IMPLMENTATIONS] */
	function setBaseURI(string memory baseTokenURI) public onlyOwner {
        _baseTokenURI = baseTokenURI;
    }

	function setTokenURI(uint256 tokenId, string memory _tokenURI) external onlyOwner {
		_setTokenURI(tokenId, _tokenURI);
	}

	
	/* [FUNCTIONS] */
	function setMintPrice(uint mintPrice) external onlyOwner {
		require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "!auth");

		_mintPrice = mintPrice;
	}

	function price() public view returns (uint) {
		return _mintPrice;
	}

	function setMint(bool state) external onlyOwner {
		_openMint = state;
	}

	function mint(address[] memory toSend) public payable onlyOwner {
		require(_openMint == true, "Minting closed");
		require(toSend.length <= 20, "Can only mint 20 tokens at a time");
		require(_tokenIdTracker.current() + toSend.length <= MAX_ROBOTS, "Purchase would exceed max supply");
		require(msg.value == _mintPrice * toSend.length, "Invalid msg.value");

		// For each address, mint the NFT
		for (uint i = 0; i < toSend.length; i++) {    
			if (totalSupply() < MAX_ROBOTS) {
				// Mint token
				_mint(toSend[i], _tokenIdTracker.current());
				
				// Increment token id
				_tokenIdTracker.increment();
			}
		}

		payable(_treasury).transfer(msg.value);
	}
}