const { ethers } = require("hardhat");

async function main() {
	const [deployer] = await ethers.getSigners();

	console.log(
		`Deploying contracts with the account: ${deployer.address}`
	);

	const CardinalProtocol = await ethers.getContractFactory(
		'CardinalProtocol'
	);

	const cardinalProtocol = await CardinalProtocol.deploy();

	console.log(`Token address: ${cardinalProtocol.address}`);
}

main()
	.then(() => {
		process.exit(0);
	})
	.catch(error => {
		console.error(error);
		process.exit(1);
	});