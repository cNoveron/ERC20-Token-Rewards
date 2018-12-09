// solium-disable linebreak-style
pragma solidity ^0.4.23;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract PriceCalculator is Ownable {

    uint16 currentFeePercentage;

    constructor(
        uint16 FeePercentage
    ) 
    public {
        currentFeePercentage = FeePercentage;
    }

    function setCurrentRewardCalculatorAddress(uint16 FeePercentage) 
    external {
        currentFeePercentage = FeePercentage;
    }

    function evaluate(uint32 reviewId, uint64 offerTimestamp, uint16 providersPrice)
    external returns(uint providersPricePlusFee) {
        uint16 fee = (providersPrice/100) * currentFeePercentage;
        providersPricePlusFee = providersPrice + fee;
    }
}