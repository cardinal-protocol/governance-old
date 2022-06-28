//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// [IMPORT]
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/escrow/Escrow.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


// [CONTRACT] diginaughts
contract diginaughts is
	Context,
	AccessControlEnumerable,
	ERC721Enumerable,
	ERC721URIStorage,
	Ownable,
	Escrow
{
	using Counters for Counters.Counter;
	
	
	Counters.Counter public _tokenIdTracker;


	string private _baseTokenURI;
	uint private _price;
	uint private _max;
	address _wallet;
	bool _openMint;
	bool _openWhitelistMint;


	mapping(address => bool) private whitelist;


	// [CONSTRUCTOR]
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
		_price = mintPrice;
		_max = max;
		_wallet = wallet;
		_openMint = false;
		_openWhitelistMint = false;
		_setupRole(DEFAULT_ADMIN_ROLE, wallet);
		_setupRole(DEFAULT_ADMIN_ROLE, admin);
	}


	function setBaseURI(string memory baseURI) external {
		require(
			hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
			"!auth"
		);
		
		_baseTokenURI = baseURI;
	}


	function _baseURI() internal view virtual override returns (string memory) {
		return _baseTokenURI;
	}


	function setTokenURI(uint256 tokenId, string memory _tokenURI) external {
		require(
			hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
			"!auth"
		);

		_setTokenURI(tokenId, _tokenURI);
	}


	function setPrice(uint mintPrice) external {
		require(
			hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
			"!auth"
		);

		_price = mintPrice;
	}


	function setMint(bool openMint, bool openWhitelistMint) external {
		require(
			hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
			"!auth"
		);

		_openMint = openMint;
		_openWhitelistMint = openWhitelistMint;
	}


	function price() public view returns (uint) {
		return _price;
	}


	function mint(address[] memory toSend) public payable onlyOwner {
		require(
			toSend.length <= 30,
			"Max of 30 NFTs per mint"
		);
		require(
			_openMint == true,
			"Minting closed"
		);
		require(
			msg.value == _price * toSend.length,
			"Invalid msg.value"
		);
		require(
			_tokenIdTracker.current() + toSend.length <= _max,
			"Not enough NFTs left to be mint amount"
		);

		// For each address to send to..
		for (uint i = 0; i < toSend.length; i++) {
			_mint(toSend[i], _tokenIdTracker.current());
			_tokenIdTracker.increment();
		}

		payable(_wallet).transfer(msg.value);
	}


	function mintWhitelist() public payable {
		require(
			_openWhitelistMint == true,
			"Minting is closed"
		);
		require(
			whitelist[msg.sender] == true,
			"User must be whitelisted to mint"
		);
		require(
			msg.value == _price,
			"Must send correct price"
		);
		require(
			_tokenIdTracker.current() < _max,
			"All NFTs have been minted"
		);
		
		whitelist[msg.sender] = false;

		_mint(msg.sender, _tokenIdTracker.current());
		
		_tokenIdTracker.increment();
		
		payable(_wallet).transfer(msg.value);
	}


	function whitelistUser(address user) public {
		require(
			hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
			"Must have admin role to whitelist address"
		);

		whitelist[user] = true;
	}


	function whitelistStatus(address user) public view returns(bool) {
		return whitelist[user];
	}


	function _burn(
		uint256 tokenId
	) internal virtual override(ERC721,ERC721URIStorage) {
		return ERC721URIStorage._burn(tokenId);
	}


	function tokenURI(
		uint256 tokenId
	) public view override(ERC721, ERC721URIStorage) returns (string memory) {
		return ERC721URIStorage.tokenURI(tokenId);
	}


	function _beforeTokenTransfer(
		address from,
		address to,
		uint256 tokenId
	) internal virtual override(ERC721, ERC721Enumerable) {
		super._beforeTokenTransfer(from, to, tokenId);
	}


	function supportsInterface(
		bytes4 interfaceId
	) public view virtual override(AccessControlEnumerable, ERC721, ERC721Enumerable) returns (bool) {
		return super.supportsInterface(interfaceId);
	}
}