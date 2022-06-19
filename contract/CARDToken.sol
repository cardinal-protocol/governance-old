// contracts/CARDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// [IMPORT]
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


contract CARDToken is ERC20, ERC20Capped, Pausable {
    // [USING-FORS]
    using SafeERC20 for CARDToken;
    

    // [EVENTS]
    event SupplyAmountSet(uint amount, address byOwner);
    

    // [VARIABLES]
    address operator;


    // [VARIABLES][MAPS]
    mapping(address => bool) pausers;
    

    // [CONSTRUCTOR]
    constructor ()
        // Token Name and Symbol
        ERC20("Cardinal Token", "CARD")
        // 100 Million Supply Cap 
        ERC20Capped(100 * 1000000 * 1e18)
    {
        operator = msg.sender;
        pausers[operator] = true;
    }
    
    
    // [MODIFIERS]
    modifier operatorOnly() { 
        require(msg.sender == operator, "!authorized");

        _;
    }
    
    modifier pauserOnly() {
        require(pausers[ msg.sender ], "!authorized");

        _;
    }


    // [FUNCTIONS][MINT]
    function _mint(
        address _to,
        uint256 _amount
    ) internal override(ERC20, ERC20Capped) operatorOnly() {
        ERC20Capped._mint(_to, _amount);
    }
    

    // [FUNCTIONS][PAUSE]
    function setAsPauser(address[] memory addresses) public operatorOnly() {
        for (uint i = 0; i < addresses.length; ++i) {
            pausers[addresses[i]] = true;
        }
    }

    function pause() public pauserOnly() {
        super._pause();
    }

    function unpause() public pauserOnly() {
        super._unpause();
    }
}