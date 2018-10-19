var Migrations = artifacts.require("Migrations");

module.exports = function(deployer) {
  deployer.deploy(
    Migrations,
    {
      from:"0xA32ac2C1646Ead762A44f1e14c3093273E118D47".toLowerCase()
    }
  );
};