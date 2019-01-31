var Pedro_ERC20Token = artifacts.require("Pedro_ERC20Token");
var ReviewsController = artifacts.require("ReviewsController");
var RewardCalculator = artifacts.require("RewardCalculator");
var PriceCalculator = artifacts.require("PriceCalculator");
var Crowdsale = artifacts.require("Crowdsale");
var FiatContract = artifacts.require("FiatContract");
var RewardsPayer = artifacts.require("RewardsPayer");
require('dotenv').config();

module.exports = function (deployer, network, accounts) {
  var sendOptions = {
    from: accounts[0]/*, 
    gas: 6721974,
    gasPrice: 1000, */
  }

  if (network == "ropsten") {
    
  }
  else if (network == "mainnet") {
    sendOptions.from = process.env.COMPROMISED_ACCOUNT.toLowerCase()
  }

  deployer.deploy(
    Pedro_ERC20Token,
    sendOptions  
  ).then(function () {
    /*
    return deployer.deploy(
      Crowdsale,
      2,
      accounts[1],
      deployedToken.address,
      sendOptions
    )
  }).then(function () {
    return deployer.deploy(
      RewardCalculator, 
      sendOptions
    )
  }).then(function() {
    return deployer.deploy(
      PriceCalculator, 
      10,
      sendOptions
    )
  }).then(function() {
    return deployer.deploy(
      ReviewsController, 
      Pedro_ERC20Token.address,
      RewardCalculator.address,
      PriceCalculator.address,
      sendOptions
    );
  }).then(function () {*/
    return deployer.deploy(
      FiatContract,
      sendOptions
    );
  }).then(function () {
    FiatContractAddress = network == 'ropsten' ?
      '0x2CDe56E5c8235D6360CCbb0c57Ce248Ca9C80909'
      :
      FiatContract.address
    
    return deployer.deploy(
      RewardsPayer,
      Pedro_ERC20Token.address,
      FiatContractAddress,
      sendOptions
    );
  });
  console.log(network)
};
