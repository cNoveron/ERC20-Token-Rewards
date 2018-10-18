var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "help later flight bench attack cinnamon news ship only ask elbow talk";

module.exports = {
  migrations_directory: "./migrations",
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*"
    },    
    ropsten: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/eQMiMPMRRHoldZ7uH7U9")
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
