const { ethers, network } = require("hardhat");
const { devlopmentChains } = require("../helper-hardhat-config");
const { verify } = require("../utils/verify");

module.exports = async function ({ getNamedAccounts, deployments }) {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();

  log("--------------------------------------------------------------------------");

  const args = ["0xAE3b2cC289Bb07858F6795C55CEeAdaC9D1ddb85", 2, 1];
  const EnglishAuction = await deploy("EnglishAuction", {
    from: deployer,
    args: args,
    log: true,
    waitConfirmations: network.config.blockconfirmations || 1,
  });

  console.log(`contract deployed : ${EnglishAuction.address} || deployer : ${deployer}`);

  if (!devlopmentChains.includes(network.name) && process.env.ETHERSCAN_API_KEY) {
    log("Verifying......");
    await verify(EnglishAuction.address, args);
  }

  log("--------------------------------------------------------------------------");
};

module.exports.tags = ["all", "EnglishAuction"];
