var Migrations = artifacts.require("Migrations");

module.exports = function(deployer, network, accounts) {
  var sendOptions = {
   from: accounts[1]
  }
  if (network == "ropsten") {
    sendOptions.from = "0xA32ac2C1646Ead762A44f1e14c3093273E118D47".toLowerCase()
  }
  deployer.deploy(Migrations, sendOptions);
};