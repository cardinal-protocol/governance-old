// contracts/CardinalProtocol.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


/* ========== [IMPORT] ========== */

// /token
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// /access
import "@openzeppelin/contracts/access/IAccessControlEnumerable.sol";


interface CardinalProtocol is IERC20, IAccessControlEnumerable {
	function owner() external view returns (address);
    function isPauser(address a) external view returns (bool);
}