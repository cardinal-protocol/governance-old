// contracts/CardinalProtocol.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


/* ========== [IMPORTS] ========== */

// Access
import "@openzeppelin/contracts/access/Ownable.sol";
// Token
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
// Security
import "@openzeppelin/contracts/security/Pausable.sol";


contract CardinalProtocol is
	Ownable,
    ERC20Capped,
    Pausable
{
    /* ========== [DEPENDENCIES] ========== */

    using SafeERC20 for CardinalProtocol;


    /* ========== [EVENTS] ========== */

    event SupplyAmountSet(uint amount, address byOwner);


    /* ========== [STATE VARIABLES] ========== */

    mapping(address => bool) pausers;

    
    /* ========== [CONSTRUCTOR] ========== */

    constructor ()
        ERC20("Cardinal Protocol", "CRDP")
        ERC20Capped(100 * 1000000 * 1e18)
    {
        pausers[msg.sender] = true;
    }

    
    /* ========== [MODIFIERS] ========== */
    
    modifier pauserOnly() {
        require(pausers[msg.sender], "!authorized");

        _;
    }


	/* ========== [FUNCTIONS][MUTATIVE] ========== */

    /*
	* Owner
	*/
    function setAsPausers(address[] memory addresses) public onlyOwner() {
        for (uint i = 0; i < addresses.length; ++i) {
            pausers[addresses[i]] = true;
        }
    }

    /*
	* Pauser
	*/
    function pause() public pauserOnly() whenNotPaused() {
        // Call Pausable "_pause" function
        super._pause();
    }

    function unpause() public pauserOnly() whenPaused() {
        // Call Pausable "_unpause" function
        super._unpause();
    }


    function mint(address _to, uint256 _amount) external
        onlyOwner()
        whenNotPaused()
    {
        // Call ERC20Capped "_mint" function
        super._mint(_to, _amount);
    }
}