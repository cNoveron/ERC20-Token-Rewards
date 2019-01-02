// solium-disable linebreak-style
pragma solidity ^0.4.23;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract PriceCalculator is Ownable {

    uint16 currentFeePercentage;

    constructor(
        uint16 FeePercentage
    ) 
    public 
    {
        currentFeePercentage = FeePercentage;
    }




    function setCurrentRewardCalculatorAddress(uint16 FeePercentage) 
    external 
    {
        currentFeePercentage = FeePercentage;
    }




    function evaluate(uint64 offerTimestamp, uint16 providersPrice)
    external 
    view
    returns(uint16 providersPricePlusFee) 
    {
        uint16 fee = uint16(providersPrice/100) * currentFeePercentage;
        providersPricePlusFee = providersPrice + fee;
    }
}