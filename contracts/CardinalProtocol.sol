// contracts/CardinalProtocol.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


/* ========== [IMPORT] ========== */

// /access
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";


contract CardinalProtocol is Ownable, AccessControlEnumerable {

    /* ========== [STATE VARIABLES] ========== */

    mapping(address => bool) _pausers;

    
    /* ========== [CONSTRUCTOR] ========== */

    constructor () {
		_setupRole(DEFAULT_ADMIN_ROLE, _msgSender());

        _pausers[msg.sender] = true;
    }

    
    /* ========== [FUNCTIONS][MUTATIVE] ========== */

    /*
	* Owner
	*/
    function setAsPausers(address[] memory addresses) public onlyOwner() {
        for (uint i = 0; i < addresses.length; ++i) {
            _pausers[addresses[i]] = true;
        }
    }


    /* ========== [FUNCTIONS][VIEW] ========== */

	function isPauser(address a) public view returns (bool) {
		return _pausers[a];
	}
}