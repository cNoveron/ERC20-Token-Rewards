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
        return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/<INFURA_Access_Token>")
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
