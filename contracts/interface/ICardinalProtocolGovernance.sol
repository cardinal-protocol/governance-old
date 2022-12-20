// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


/**
* @title ICardinalProtocolGovernance
*/
interface ICardinalProtocolGovernance 
{
	/**
	* @notice AccessControl Role
	* @return {bytes32} keccak256 value
	*/
	function S() external view returns (bytes32);

	/**
	* @notice AccessControl Role
	* @return {bytes32} keccak256 value
	*/
	function A() external view returns (bytes32);

	/**
	* @notice AccessControl Role
	* @return {bytes32} keccak256 value
	*/
	function B() external view returns (bytes32);

	/**
	* @notice AccessControl Role
	* @return {bytes32} keccak256 value
	*/
	function C() external view returns (bytes32);
}