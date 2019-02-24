// solium-disable linebreak-style
pragma solidity ^0.4.15;

import "./Pedro_ERC20Token.sol";
import "./FiatContract.sol";

contract RewardsPayer {
  
  Pedro_ERC20Token pedro_ERC20Token;
  address public currentToken;
  
  FiatContract fiatContract;
  address public currentFiatContract;

  uint256 public USDCent_inETHWei;

  uint256 public tokenPrice_inETHWei;

  constructor(
    address pedro_ERC20TokenAddress,
    address currentFiatContractAddress
  )
  public 
  payable
  {
    currentToken = pedro_ERC20TokenAddress;
    pedro_ERC20Token = Pedro_ERC20Token(currentToken);
    
    currentFiatContract = currentFiatContractAddress;
    fiatContract = FiatContract(currentFiatContractAddress);
  }



  function setCurrentTokenAddress(address Pedro_ERC20TokenAddress) 
  external 
  {
    currentToken = Pedro_ERC20TokenAddress;
    pedro_ERC20Token = Pedro_ERC20Token(currentToken);
  }



  function update_USDCent_inETHWei()
  public
  returns(
    uint256
  )
  {
    USDCent_inETHWei = fiatContract.USD(0);
    tokenPrice_inETHWei = USDCent_inETHWei.mul(45);
    return USDCent_inETHWei;
  }


  using SafeMath for uint256;

  function pay(
/*     uint32 review_id,
    uint32 provider_id,
    bool service_done,
    bool hire_again,
    uint8 overall_rating, */
    uint service_price, /** @param service_price Price in USD cents. 1 USD = 100 USD cents */
/*     uint8 price_satisfaction,
    uint8 responsiveness,
    uint8 professionalism,
    uint8 satisfaction */
    address consumer,
    address provider
  )
  public
  {
    uint256 tokenAmount = _rewardAmount(service_price);
    pedro_ERC20Token.transfer(consumer, tokenAmount);
    pedro_ERC20Token.transfer(provider, tokenAmount);
  }

  

  function getRewardAmount(uint service_price)
  public
  view
  returns(
    uint256 rewardAmount
  )
  {
    rewardAmount = _rewardAmount(service_price);
  }



  function _rewardAmount(uint service_price) 
  internal
  view
  returns(
    uint256 rewardAmount
  )
  {
    rewardAmount = _fractionOfPrice(service_price).div(tokenPrice_inETHWei);
  }



  function fractionOfPrice(uint service_price) 
  public
  view
  returns(
    uint256 fractionOfPrice_inETHWei
  )
  {
    fractionOfPrice_inETHWei = _fractionOfPrice(service_price);
  }



  function _fractionOfPrice(uint service_price) 
  internal
  view
  returns(
    uint256 fractionOfPrice_inETHWei
  )
  {
    uint256 fractionOfPrice_inUSDCents = service_price.div(10);
    fractionOfPrice_inETHWei = USDCent_inETHWei.mul(fractionOfPrice_inUSDCents);
  }
}