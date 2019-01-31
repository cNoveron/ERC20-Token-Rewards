var Migrations = artifacts.require("Migrations");

module.exports = function(deployer, network, accounts) {
  var sendOptions = {
   from: accounts[0]
  }
  if (network == "ropsten") {
    
  }
  deployer.deploy(Migrations, sendOptions);
};