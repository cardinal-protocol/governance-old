// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface IUniswapV2Router {
	function getAmountsOut(uint256 amountIn, address[] memory path)
	external
	view
	returns (uint256[] memory amounts);

	// amountIn: amount of tokens we are sending in
	// amountOutMin: the minimum amount of tokens we want out of the trade
	// path: list of token addresses we are going to trade in.  this is necessary to calculate amounts
	// to: this is the address we are going to send the output tokens to
	// deadline: the last time that the trade is valid for
	function swapExactTokensForTokens(
		uint256 amountIn,
		uint256 amountOutMin,
		address[] calldata path,
		address to,
		uint256 deadline
	) external returns (uint256[] memory amounts);
}