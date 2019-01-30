// solium-disable linebreak-style
pragma solidity ^0.4.23;

import "./Pedro_ERC20Token.sol";

contract RewardsPayer {
  
  Pedro_ERC20Token pedro_ERC20Token;
  address currentPedro_ERC20Token;
  



  constructor(
    address pedro_ERC20TokenAddress
  ) 
  public 
  {
    currentPedro_ERC20Token = pedro_ERC20TokenAddress;
    pedro_ERC20Token = Pedro_ERC20Token(currentPedro_ERC20Token);
  }




  function setCurrentPedro_ERC20TokenAddress(address Pedro_ERC20TokenAddress) 
  external 
  {
    currentPedro_ERC20Token = Pedro_ERC20TokenAddress;
    pedro_ERC20Token = Pedro_ERC20Token(currentPedro_ERC20Token);
  }




  function pay(
    uint32 review_id,
    uint32 provider_id,
    bool service_done,
    bool hire_again,
    uint8 overall_rating,
    uint service_price,
    uint8 price_satisfaction,
    uint8 responsiveness,
    uint8 professionalism,
    uint8 satisfaction
  )
  external
  returns(
    uint rewardAmount
  )
  {
  }

}