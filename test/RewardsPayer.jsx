var Pedro_ERC20Token = artifacts.require("Pedro_ERC20Token");
var FiatContract = artifacts.require("FiatContract");
var RewardsPayer = artifacts.require("RewardsPayer");

contract("RewardsPayer", async accounts => {

  async function deployEverything() {
    await Pedro_ERC20Token.deployed();
    await FiatContract.deployed();
    await RewardsPayer.deployed();
  }

  it("Should pass.", async () => {
    await deployEverything();
    assert.equal(await rewardsPayer.currentFiatContract(), fiatContract.address, 'LOL');

  });

});
