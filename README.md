# Pedros_List

## Test

```(JavaScript)
truffle(ropsten)> RewardsPayer.at('0x5dfcd1997a9f20c5ba7dff8151bf86055806aaf5').getRewardAmount(10000)
```
Should return: `BigNumber { s: 1, e: 13, c: [ 92764494250000 ] }`

```(JavaScript)
truffle(ropsten)> RewardsPayer.at('0x5dfcd1997a9f20c5ba7dff8151bf86055806aaf5').USDCent_inETHWei()
```
Should return: `BigNumber { s: 1, e: 13, c: [ 92764494250000 ] }`

```(JavaScript)
truffle(ropsten)> RewardsPayer.at('0x5dfcd1997a9f20c5ba7dff8151bf86055806aaf5').currentFiatContract()
```
Should return: `'0x2cde56e5c8235d6360ccbb0c57ce248ca9c80909'`

```(JavaScript)
truffle(ropsten)> RewardsPayer.at('0x5dfcd1997a9f20c5ba7dff8151bf86055806aaf5').currentToken()
```
Should return: `'0xf5f6a28058ff9f01292bbd9395a4411d7e18e057'`