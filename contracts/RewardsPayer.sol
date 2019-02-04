// solium-disable linebreak-style
pragma solidity ^0.4.23;

import "./Pedro_ERC20Token.sol";

contract RewardsPayer {
  
  Pedro_ERC20Token pedro_ERC20Token;
  address public currentToken;
  
  FiatContract fiatContract;
  address public currentFiatContract;

  uint256 USDCent_inETHWei;

  constructor(
    address pedro_ERC20TokenAddress,
    address currentFiatContractAddress
  ) 
  public 
  {
    USDCent_inETHWei = fiatContract.USD(0);

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
  {
    USDCent_inETHWei = fiatContract.USD(0);
  }


  using SafeMath for uint256;
  using SafeERC20 for Pedro_ERC20Token;

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
    pedro_ERC20Token.safeTransfer(consumer, tokenAmount);
    pedro_ERC20Token.safeTransfer(provider, tokenAmount);
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




/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure.
 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
  function safeTransfer(
    Pedro_ERC20Token _token,
    address _to,
    uint256 _value
  )
    internal
  {
    require(_token.transfer(_to, _value),"Could not safely transfer from that address.");
  }

  function safeTransferFrom(
    Pedro_ERC20Token _token,
    address _from,
    address _to,
    uint256 _value
  )
    internal
  {
    require(_token.transferFrom(_from, _to, _value),"Could not safely transfer from that address.");
  }

  function safeApprove(
    Pedro_ERC20Token _token,
    address _spender,
    uint256 _currentValue,
    uint256 _value
  )
    internal
  {
    require(_token.approve(_spender, _currentValue, _value),"Could not safely approve, check current approved value.");
  }
}