// contracts/uniswapSwapper.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


/* ========== [IMPORT] ========== */

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


/* ========== [IMPORT] Personal ========== */

import "./interface/IUniswapV2Router.sol";


/// @title
contract tokenSwap {
	/* ========== [STATE VARIABLES] ========== */

    address private constant UNISWAP_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    /// @notice this swap function is used to trade from one token to another
    /// @param _tokenIn Input token address (SwapOut)
    /// @param _tokenOut Output token address (SwapIn)
    /// @param _amountIn The amount of tokens being sent in
    /// @param _amountOutMin Expected minimum amount to be recieved
    /// @param _to Recieving adderss
	function swap(
		address _tokenIn,
		address _tokenOut,
		uint256 _amountIn,
		uint256 _amountOutMin,
		address _to
	) external {
		// first we need to transfer the amount in tokens from the msg.sender to this
		// contract this contract will have the amount of in tokens
		IERC20(_tokenIn).transferFrom(
			msg.sender,
			address(this),
			_amountIn
		);
		
		// Allow the uniswapv2 router to spend the token we just sent to this contract
		IERC20(_tokenIn).approve(
			UNISWAP_V2_ROUTER,
			_amountIn
		);

		// path is an array of addresses.
		// this path array will have 3 addresses [tokenIn, WETH, tokenOut]
		// the if statement below takes into account if token in or token out is WETH.  then the path is only 2 addresses
		address[] memory path;

		if (_tokenIn == WETH || _tokenOut == WETH) {
			path = new address[](2);
			path[0] = _tokenIn;
			path[1] = _tokenOut;
		}
		else {
			path = new address[](3);
			path[0] = _tokenIn;
			path[1] = WETH;
			path[2] = _tokenOut;
		}

        // then we will call swapExactTokensForTokens
        // for the deadline we will pass in block.timestamp
        // the deadline is the latest time the trade is valid for
        IUniswapV2Router(UNISWAP_V2_ROUTER).swapExactTokensForTokens(
			_amountIn,
			_amountOutMin,
			path,
			_to,
			block.timestamp
		);
    }
    
	// this function will return the minimum amount from a swap
	// input the 3 parameters below and it will return the minimum amount out
	// this is needed for the swap function above
	function getAmountOutMin(
		address _tokenIn,
		address _tokenOut,
		uint256 _amountIn
	) external view returns (uint256) {
		// [INIT]
		address[] memory path;

		if (_tokenIn == WETH || _tokenOut == WETH) {
			path = new address[](2);
			path[0] = _tokenIn;
			path[1] = _tokenOut;
		} else {
			path = new address[](3);
			path[0] = _tokenIn;
			path[1] = WETH;
			path[2] = _tokenOut;
		}
		
		uint256[] memory amountOutMins = IUniswapV2Router(
			UNISWAP_V2_ROUTER
		).getAmountsOut(_amountIn, path);

		return amountOutMins[path.length - 1];  
	}
}