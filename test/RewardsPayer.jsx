var Pedro_ERC20Token = artifacts.require("Pedro_ERC20Token");
var FiatContract = artifacts.require("FiatContract");
var RewardsPayer = artifacts.require("RewardsPayer");

contract("RewardsPayer", async accounts => {

  const [owner, requester, offerer] = [...accounts];
  console.log([owner, requester, offerer]);

  var pedro_ERC20Token, fiatContract, rewardsPayer;

  async function deployEverything() {

    pedro_ERC20Token = await Pedro_ERC20Token.deployed();
    fiatContract = await FiatContract.deployed();
    rewardsPayer = await RewardsPayer.deployed();

    return await [
      pedro_ERC20Token,
      fiatContract,
      rewardsPayer,
    ]
    
  }

  it("Should pass.", async () => {
    await deployEverything();
    assert.equal(await rewardsPayer.currentFiatContract(), fiatContract.address, 'LOL');

  });

});
