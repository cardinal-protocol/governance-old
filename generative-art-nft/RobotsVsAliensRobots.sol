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
contract RobotsVsAliensRobots is
	AccessControlEnumerable,
	ERC721Enumerable,
	ERC721URIStorage,
	Escrow
{
	// using for
	using Counters for Counters.Counter;


	// init
	string private _baseTokenURI;
	uint private _mintPrice;
	uint private _max;
	address _wallet;
	bool _openMint;


	// init - mapping
	mapping(address => bool) private whitelist;


	// init - Custom Data Types
	Counters.Counter public _tokenIdTracker;


	/* [CONSTRUCTOR] */
	constructor (
		string memory name,
		string memory symbol,
		string memory baseTokenURI,
		uint mintPrice,
		uint max,
		address wallet,
		address admin
	) ERC721(name, symbol) {
		_baseTokenURI = baseTokenURI;
		_mintPrice = mintPrice;
		_max = max;
		_wallet = wallet;
		_openMint = false;
		
		_setupRole(DEFAULT_ADMIN_ROLE, wallet);
		_setupRole(DEFAULT_ADMIN_ROLE, admin);
	}


	/* [OVERRIDE-REQUIRED-FUNCTIONS] */
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


	/* [REQUIRED-FUNCTIONS] */
	// Must implement access control utilties here


	/* [FUNCTIONS] */
	function setBaseURI(string memory baseURI) public onlyOwner {
        _baseTokenURI = baseURI;
    }


	function _baseURI() internal view virtual override returns (string memory) {
		return _baseTokenURI;
	}


	function setTokenURI(uint256 tokenId, string memory _tokenURI) external onlyOwner {
		_setTokenURI(tokenId, _tokenURI);
	}


	function setPrice(uint mintPrice) external onlyOwner {
		_mintPrice = mintPrice;
	}


	function setMint(bool openMint) external onlyOwner {
		_openMint = openMint;
	}


	function price() public view returns (uint) {
		return _mintPrice;
	}


	function mint(address[] memory toSend) public payable onlyOwner {
		require(toSend.length <= 30, "Max of 30 NFTs per mint");
		require(_openMint == true, "Minting closed");
		require(msg.value == _mintPrice * toSend.length, "Invalid msg.value");
		require(_tokenIdTracker.current() + toSend.length <= _max, "Not enough NFTs left to be mint amount");

		// For each address, mint the NFT
		for (uint i = 0; i < toSend.length; i++) {
			// Mint token
			_mint(toSend[i], _tokenIdTracker.current());

			// Increment token id
			_tokenIdTracker.increment();
		}

		payable(_wallet).transfer(msg.value);
	}
}