require('dotenv').config();
require("@nomicfoundation/hardhat-verify");

const { API_URL, PRIVATE_KEY, ARBISCAN_API_KEY } = process.env;
require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-ignition-ethers");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  networks: {
    hardhat: {},
    sepolia: {
      url: API_URL,
      accounts: [`0x${PRIVATE_KEY}`]
    }
  },
  etherscan: {
    apiKey: {
      arbitrumSepolia: ARBISCAN_API_KEY
    }
  },
};
