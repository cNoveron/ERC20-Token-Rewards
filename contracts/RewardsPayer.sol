// solium-disable linebreak-style
pragma solidity ^0.4.23;

import "./Pedro_ERC20Token.sol";

contract RewardsPayer {
  
  Pedro_ERC20Token pedro_ERC20Token;
  address public currentToken;



  constructor(
    address pedro_ERC20TokenAddress
  ) 
  public 
  {
    currentToken = pedro_ERC20TokenAddress;
    pedro_ERC20Token = Pedro_ERC20Token(currentToken);
  }




  function setCurrentTokenAddress(address Pedro_ERC20TokenAddress) 
  external 
  {
    currentToken = Pedro_ERC20TokenAddress;
    pedro_ERC20Token = Pedro_ERC20Token(currentToken);
  }




  function pay(
    uint32 review_id,
    uint32 provider_id,
    bool service_done,
    bool hire_again,
    uint8 overall_rating,
    uint service_price, /** @param service_price Price in USD cents. 1 USD = 100 USD cents */
    uint8 price_satisfaction,
    uint8 responsiveness,
    uint8 professionalism,
    uint8 satisfaction
  )
  public
  view
  returns(
    uint rewardAmount
  )
  {
  }

}