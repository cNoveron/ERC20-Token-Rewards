// solium-disable linebreak-style
pragma solidity ^0.4.23;

import "./Pedro_ERC20Token.sol";

contract RewardsPayer {
  
  Pedro_ERC20Token pedro_ERC20Token;
  address public currentToken;
  
  FiatContract fiatContract;
  address public currentFiatContract;



  constructor(
    address pedro_ERC20TokenAddress,
    address currentFiatContractAddress
  ) 
  public 
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



  using SafeMath for uint256;

  function pay(
/*     uint32 review_id,
    uint32 provider_id,
    bool service_done,
    bool hire_again,
    uint8 overall_rating, */
    uint service_price /** @param service_price Price in USD cents. 1 USD = 100 USD cents */
/*     uint8 price_satisfaction,
    uint8 responsiveness,
    uint8 professionalism,
    uint8 satisfaction */
  )
  public
  view
  returns(
    uint256 rewardAmount
  )
  {
    uint256 USDCent_inETHWei = fiatContract.USD(0);
    uint256 tokenPrice_inETHWei = USDCent_inETHWei.mul(45);

    uint256 fractionOfPrice_inUSDCents = service_price.div(10);
    uint256 fractionOfPrice_inETHWei = USDCent_inETHWei.mul(fractionOfPrice_inUSDCents);

    rewardAmount = fractionOfPrice_inETHWei.div(tokenPrice_inETHWei);
  }

}

interface FiatContract {
  function ETH(uint _id) external view returns (uint256);
  function USD(uint _id) external view returns (uint256);
  function EUR(uint _id) external view returns (uint256);
  function GBP(uint _id) external view returns (uint256);
  function updatedAt(uint _id) external view returns (uint);
}