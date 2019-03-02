const deployEverything = async () => [
  await artifacts.require("Pedro_ERC20Token").deployed(),
  await artifacts.require("FiatContract").deployed(),
  await artifacts.require("RewardsPayer").deployed()
]

contract("RewardsPayer", async accounts => {

  it("RewardsPayer.currentToken() should return the address of Pedro_ERC20Token in the network.", async () => {

    let [Pedro_ERC20Token, FiatContract, RewardsPayer] = await deployEverything()

    assert.equal(
      await RewardsPayer.currentToken.call(),
      Pedro_ERC20Token.address,
      "Pedro_ERC20Token addresses are not equal."
    );
  });

  it("RewardsPayer.currentFiatContract() should return the address of FiatContract in the network.", async () => {

    let [Pedro_ERC20Token, FiatContract, RewardsPayer] = await deployEverything()

    assert.equal(
      await RewardsPayer.currentFiatContract.call(),
      FiatContract.address,
      "FiatContract addresses are not equal."
    );

  });

});
