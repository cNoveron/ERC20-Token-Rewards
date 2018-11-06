var Pedro_ERC20Token = artifacts.require("Pedro_ERC20Token");

module.exports = function(deployer, network, accounts) {
  var sendOptions = {
    from: accounts[0]
   }
   if (network == "ropsten") {
     sendOptions.from = "0xA32ac2C1646Ead762A44f1e14c3093273E118D47".toLowerCase()
   } /* else {
     // Perform a different step otherwise.
   } */
   deployer.deploy(Pedro_ERC20Token,sendOptions);
};
