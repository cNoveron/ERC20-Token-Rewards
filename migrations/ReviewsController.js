var Pedro_ERC20Token = artifacts.require("Pedro_ERC20Token");
var ReviewsController = artifacts.require("ReviewsController");
var RewardCalculator = artifacts.require("RewardCalculator");
var PriceCalculator = artifacts.require("PriceCalculator");

module.exports = async (deployer, network, accounts) => {

  var addresses = require("./getAddresses.js")(network)
  var sendOptions = require("./getSendOptions.js")(network, accounts)

  const asyncDeploy = async (contract) => await deployer.deploy(contract, sendOptions)

  asyncDeploy(Pedro_ERC20Token)
  asyncDeploy(RewardCalculator)

  await deployer.deploy(
    PriceCalculator,
    10,
    sendOptions
  );

  await deployer.deploy(
    ReviewsController,
    addresses.Pedro_ERC20Token(),
    addresses.RewardCalculator(),
    addresses.PriceCalculator(),
    sendOptions
  );
};
