// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// [IMPORT]
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CARDToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("Cardinal", "CARDINAL") {
        _mint(msg.sender, initialSupply);
    }
}