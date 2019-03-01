var HDWalletProvider = require("truffle-hdwallet-provider");

require('dotenv').config();

module.exports = {
  migrations_directory: "./migrations",
  networks: {
    development: {
      host: "localhost",
      port: 7545,
      network_id: 5777
    },
    ganache: {
      host: "localhost",
      port: 7545,
      network_id: 5777
    },
    mainnet: {
      provider: function () {
        return new HDWalletProvider(
          process.env.MNEMONIC,
          "https://mainnet.infura.io/v3/" + process.env.INFURA_APIKEY, 0, 10, "m/44'/60'/0'/0/0"
        )
      },
      network_id: 1
    },
    ropsten: {
      provider: function () {
        return new HDWalletProvider(
          process.env.MNEMONIC,
          "https://ropsten.infura.io/v3/" + process.env.INFURA_APIKEY, 0, 10, "m/44'/60'/0'/0/0"
        )
      },
      network_id: 3
    },
    rinkeby: {
      provider: function () {
        return new HDWalletProvider(
          process.env.MNEMONIC,
          "https://rinkeby.infura.io/v3/" + process.env.INFURA_APIKEY, 0, 10, "m/44'/60'/0'/0/0"
        )
      },
      network_id: 4
    }
  },
  compilers: {
    solc: {
      version: "^0.4.15"
    }
  }
};
