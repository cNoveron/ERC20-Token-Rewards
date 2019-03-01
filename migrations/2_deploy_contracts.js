var Pedro_ERC20Token = artifacts.require("Pedro_ERC20Token");
var FiatContract = artifacts.require("FiatContract");
var RewardsPayer = artifacts.require("RewardsPayer");

module.exports = async (deployer, network, accounts) => {

  const sendOptions = require("./getSendOptions.js")(network, accounts)

  if (network !== 'mainnet')
    await deployer.deploy(Pedro_ERC20Token, sendOptions)

  if (network !== 'mainnet' && network !== 'ropsten')
    await deployer.deploy(FiatContract, sendOptions)

  await deployer.deploy(
    RewardsPayer,
    Pedro_ERC20Token.address,
    FiatContract.address,
    sendOptions
  )

};
