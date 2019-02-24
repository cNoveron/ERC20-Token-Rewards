var Pedro_ERC20Token = artifacts.require("Pedro_ERC20Token");
var Crowdsale = artifacts.require("Crowdsale");

module.exports = async (deployer, network, accounts) => {

  var addresses = require("./getAddresses.js")(network)
  var sendOptions = require("./getSendOptions.js")(network, accounts)

  const asyncDeploy = async (contract) => await deployer.deploy(contract, sendOptions)

  await Pedro_ERC20Token.deployed()
  asyncDeploy(Crowdsale)

  await deployer.deploy(
    Crowdsale,
    2,
    addresses.owner,
    addresses.Pedro_ERC20Token(),
    sendOptions
  );
};
