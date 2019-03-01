var Pedro_ERC20Token = artifacts.require("Pedro_ERC20Token");
var FiatContract = artifacts.require("FiatContract");
var RewardsPayer = artifacts.require("RewardsPayer");

contract("RewardsPayer", async accounts => {

  async function deployEverything() {
    await Pedro_ERC20Token.deployed();
    await FiatContract.deployed();
    await RewardsPayer.deployed();
  }

  it("RewardsPayer.currentToken() should return the address of Pedro_ERC20Token in the network.", async () => {
    await deployEverything();
    assert.equal(
      await (await RewardsPayer.deployed()).currentToken.call(),
      (await Pedro_ERC20Token.deployed()).address,
      "Pedro_ERC20Token addresses are not equal."
    );
  });

  it("RewardsPayer.currentFiatContract() should return the address of FiatContract in the network.", async () => {
    await deployEverything();
    assert.equal(
      await (await RewardsPayer.deployed()).currentFiatContract.call(),
      (await FiatContract.deployed()).address,
      "FiatContract addresses are not equal."
    );
  });
});
