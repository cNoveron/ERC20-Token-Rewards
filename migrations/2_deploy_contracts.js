var Pedro_ERC20Token = artifacts.require("Pedro_ERC20Token");

module.exports = function(deployer) {
  deployer.deploy(
    Pedro_ERC20Token,
    {
      from:"0xa32ac2c1646ead762a44f1e14c3093273e118d47"
    }
  );
};
