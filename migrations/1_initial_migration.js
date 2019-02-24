var Migrations = artifacts.require("Migrations");

module.exports = async (deployer, network, accounts) => {
  
  var sendOptions = require("./getSendOptions.js")(network, accounts)

  deployer.deploy(Migrations, sendOptions)
};