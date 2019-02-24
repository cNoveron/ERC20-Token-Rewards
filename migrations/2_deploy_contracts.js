var Pedro_ERC20Token = artifacts.require("Pedro_ERC20Token");
var ReviewsController = artifacts.require("ReviewsController");
var RewardCalculator = artifacts.require("RewardCalculator");
var PriceCalculator = artifacts.require("PriceCalculator");
var Crowdsale = artifacts.require("Crowdsale");
var FiatContract = artifacts.require("FiatContract");
var RewardsPayer = artifacts.require("RewardsPayer");

module.exports = async (deployer, network, accounts) => {

  var addresses = require("./getAddresses.js")(network)
  var sendOptions = require("./getSendOptions.js")(network, accounts)

  deployer.deploy(Pedro_ERC20Token, sendOptions)
  deployer.deploy(FiatContract, sendOptions)

  deployer.deploy(
    RewardsPayer,
    addresses.Pedro_ERC20Token(),
    addresses.FiatContract(),
    sendOptions
  );

  // await deployer.deploy(
  //   Crowdsale,
  //   2,
  //   accounts[0],
  //   deployedToken.address,
  //   sendOptions
  // );

  // await deployer.deploy(
  //   RewardCalculator,
  //   sendOptions
  // );

  // await deployer.deploy(
  //   PriceCalculator,
  //   10,
  //   sendOptions
  // );

  // await deployer.deploy(
  //   ReviewsController,
  //   Pedro_ERC20Token.address,
  //   RewardCalculator.address,
  //   PriceCalculator.address,
  //   sendOptions
  // );
};
