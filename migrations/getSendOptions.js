require("dotenv").config();

module.exports = (network, accounts) => {

  const from = () => {
    switch (network) {
      case "develop": return accounts[0];
      case "ganache": return accounts[0];
      case "ropsten": return accounts[0];
      case "rinkeby": return accounts[0];
      case "mainnet": return accounts[0];
      default: return accounts[0];
    }
  };

  const gas = () => {
    switch (network) {  
      case "develop": return 6721974;
      case "ganache": return 8000000;
      case "ropsten": return 8000000;
      case "rinkeby": return 6990000;
      case "mainnet": return 6990000;
    }
  };

  const gasPrice = () => {
    switch(network) {
      case "develop": return 1000000000;   // 1 GWei
      case "ganache": return 1000000000;   // 1 GWei
      case "ropsten": return 1000000000;   // 1 GWei
      case "rinkeby": return 10000000000;  // 10 GWei
      case "mainnet": return 10000000000;  // 10 GWei
    }
  }

  return {
    from: from(),
    gas: gas(),
    gasPrice: gasPrice()
  }
}