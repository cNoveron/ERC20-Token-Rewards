// solium-disable linebreak-style
pragma solidity ^0.4.23;

import "./IServiceStateController.sol";
import "./RewardCalculator.sol";
import "./Pedro_ERC20Token.sol";

contract ReviewsController is IServiceStateController {
  
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

}