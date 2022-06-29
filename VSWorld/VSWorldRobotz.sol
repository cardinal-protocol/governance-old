// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


/* [IMPORT] */
// access
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
// token
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
// utils
import "@openzeppelin/contracts/utils/Counters.sol";



/* [MAIN-CONTRACT] */
contract VSWorldRobotz is
	AccessControlEnumerable,
	ERC721Enumerable,
	Ownable
{
	// using for
	using Counters for Counters.Counter;


	// init
	address public _treasury;
	bool public _openMint = false;	
	string public _baseTokenURI;
	uint public _mintPrice;


	// init - const
	string public PROVENANCE = "";
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
		address treasury
	) ERC721(name, symbol) {
		MAX_ROBOTS = max;

		_baseTokenURI = baseTokenURI;
		_mintPrice = mintPrice;
		_treasury = treasury;
		
		_setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
		_setupRole(DEFAULT_ADMIN_ROLE, treasury);
	}


	/* [FUNCTIONS][OVERRIDE][REQUIRED] */
	function _burn(uint256 tokenId) internal virtual override(ERC721) {
		return ERC721._burn(tokenId);
	}

	function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
		return ERC721.tokenURI(tokenId);
	}

	function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
		super._beforeTokenTransfer(from, to, tokenId);
	}

	function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControlEnumerable, ERC721Enumerable) returns (bool) {
		return super.supportsInterface(interfaceId);
	}


	/* [FUNCTIONS][OVERRIDE] */
	function _baseURI() internal view virtual override returns (string memory) {
		return _baseTokenURI;
	}


	/* [FUNCTIONS][SELF-IMPLMENTATIONS] */
	function setBaseURI(string memory baseTokenURI) external onlyOwner {
        _baseTokenURI = baseTokenURI;
    }

	
	/* [FUNCTIONS] */
	function withdrawToTreasury() public onlyOwner {
        uint balance = address(this).balance;
        
		payable(_treasury).transfer(balance);
    }

	function setProvenanceHash(string memory provenanceHash) public onlyOwner {
        PROVENANCE = provenanceHash;
    }

	function setMintPrice(uint mintPrice) public onlyOwner {
		_mintPrice = mintPrice;
	}

	function price() public view returns (uint) {
		return _mintPrice;
	}

    function reserveTokens() public onlyOwner {        
        for (uint i = 0; i < 30; i++) {
			if (totalSupply() < MAX_ROBOTS) {
				_mint(_treasury, _tokenIdTracker.current());

				// Increment token id
				_tokenIdTracker.increment();
			}
        }
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