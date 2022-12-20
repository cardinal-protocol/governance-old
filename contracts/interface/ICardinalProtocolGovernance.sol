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

	/**
	* @notice AccessControl Role
	* @return {bool}
	*/
	function hasClearanceAdmin(address a) external view returns (bool);

	/**
	* @notice AccessControl Role
	* @return {bool}
	*/
	function hasClearanceS(address a) external view returns (bool);

	/**
	* @notice AccessControl Role
	* @return {bool}
	*/
	function hasClearanceA(address a) external view returns (bool);

	/**
	* @notice AccessControl Role
	* @return {bool}
	*/
	function hasClearanceB(address a) external view returns (bool);

	/**
	* @notice AccessControl Role
	* @return {bool}
	*/
	function hasClearanceC(address a) external view returns (bool);
}