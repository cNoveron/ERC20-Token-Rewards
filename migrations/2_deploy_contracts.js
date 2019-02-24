var Pedro_ERC20Token = artifacts.require("Pedro_ERC20Token");
var Crowdsale = artifacts.require("Crowdsale");
var FiatContract = artifacts.require("FiatContract");
var RewardsPayer = artifacts.require("RewardsPayer");

module.exports = async (deployer, network, accounts) => {

  var addresses = require("./getAddresses.js")(network)
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

  // await deployer.deploy(
  //   Crowdsale,
  //   2,
  //   accounts[0],
  //   deployedToken.address,
  //   sendOptions
  // );
};
