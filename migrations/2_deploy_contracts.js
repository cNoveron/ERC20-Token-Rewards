var Pedro_ERC20Token = artifacts.require("Pedro_ERC20Token");
var FiatContract = artifacts.require("FiatContract");
var RewardsPayer = artifacts.require("RewardsPayer");

module.exports = async (deployer, network, accounts) => {

  var addresses = require("./getAddresses.js")(network, accounts)
  var sendOptions = require("./getSendOptions.js")(network, accounts)

  const asyncDeploy = async (contract) => await deployer.deploy(contract, sendOptions)

  asyncDeploy(Pedro_ERC20Token)

  if (network !== 'ropsten') 
    asyncDeploy(FiatContract)

  deployer.deploy(
    RewardsPayer,
    addresses.Pedro_ERC20Token(),
    addresses.FiatContract(),
    sendOptions
  );
};
