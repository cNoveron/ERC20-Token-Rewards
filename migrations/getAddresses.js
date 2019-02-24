var contracts = {
  Pedro_ERC20Token: require("../build/contracts/Pedro_ERC20Token.json"),
  ReviewsController: require("../build/contracts/ReviewsController.json"),
  RewardCalculator: require("../build/contracts/RewardCalculator.json"),
  PriceCalculator: require("../build/contracts/PriceCalculator.json"),
  Crowdsale: require("../build/contracts/Crowdsale.json"),
  FiatContract: require("../build/contracts/FiatContract.json"),
  RewardsPayer: require("../build/contracts/RewardsPayer.json"),
}

module.exports = (network) => {

  const [owner, requester, offerer] = [...accounts];

  function Pedro_ERC20Token() {
    switch (network) {
      case "develop": return contracts.Pedro_ERC20Token.networks[4447].address;
      case "ganache": return contracts.Pedro_ERC20Token.networks[5777].address;
      case "ropsten": return contracts.Pedro_ERC20Token.networks[3].address;
      case "rinkeby": return contracts.Pedro_ERC20Token.networks[4].address;
      case "mainnet": return contracts.Pedro_ERC20Token.networks[1].address;
    }
  };

  function FiatContract() {
    switch (network) {
      case "develop": return contracts.FiatContract.networks[4447].address;
      case "ganache": return contracts.FiatContract.networks[5777].address;
      case "ropsten": return "0x2CDe56E5c8235D6360CCbb0c57Ce248Ca9C80909";
      case "rinkeby": return contracts.FiatContract.networks[4].address;
      case "mainnet": return contracts.FiatContract.networks[1].address;
    }
  };

  return { Pedro_ERC20Token, FiatContract, owner, requester, offerer }
}