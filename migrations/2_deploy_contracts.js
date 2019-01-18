var Pedro_ERC20Token = artifacts.require("Pedro_ERC20Token");
var ReviewsController = artifacts.require("ReviewsController");
var RewardCalculator = artifacts.require("RewardCalculator");
var PriceCalculator = artifacts.require("PriceCalculator");
require('dotenv').config();

module.exports = function(deployer, network, accounts) {
    var sendOptions = {
      from: accounts[1]
    }
    if (network == "ropsten") {
      sendOptions.from = "0xA32ac2C1646Ead762A44f1e14c3093273E118D47".toLowerCase()
    }
    else if (network == "mainnet") {
      sendOptions.from = process.env.COMPROMISED_ACCOUNT.toLowerCase()
    }
    deployer.deploy(
      Pedro_ERC20Token,
      sendOptions
    ).then(function () {
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
    });
};
