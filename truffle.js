var HDWalletProvider = require("truffle-hdwallet-provider");

require('dotenv').config();

module.exports = {
  migrations_directory: "./migrations",
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*",
      from: "0xC7e76e5f1D33BE441E890a7F2aCE9468f40345C7",
      gas: 21000000,
      gasPrice: 6
    },
    mainnet: {
      provider: function () {
        return new HDWalletProvider(
          process.env.MNEMONIC,
          "https://mainnet.infura.io/" + process.env.INFURA_APIKEY, 0, 10, "m/44'/60'/0'/0/0"
        )
      },
      network_id: 1
    },
    ropsten: {
      provider: function () {
        return new HDWalletProvider(
          process.env.MNEMONIC,
          "https://ropsten.infura.io/" + process.env.INFURA_APIKEY, 0, 10, "m/44'/60'/0'/0/0"
        )
      },
      network_id: 3
    }
  },
  solc: {
    optimizer: {
      enabled: true,
      runs: 500
    }
  }
};
