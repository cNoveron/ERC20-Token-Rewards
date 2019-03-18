(await FiatContract.at('0xfA8299cb79775f38Deb0CE99142D719242155f27')).constructor._json

let fiatContract = new web3.eth.Contract(
  (await FiatContract.at('0xfA8299cb79775f38Deb0CE99142D719242155f27')).constructor._json,
  '0xfA8299cb79775f38Deb0CE99142D719242155f27',
  { from: '0x5D27111dc74f9450a3D2400207385A8a1e59d260' }
)

let FiatContract = (await FiatContract.at('0xfA8299cb79775f38Deb0CE99142D719242155f27'))

FiatContract.contract.methods.update(0, "ETH", 10, 70588498180000, 80037647520000, 93872128050000).call()

FiatContract.contract.events.NewPrice({ fromBlock: 0 }, console.log)