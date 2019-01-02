// solium-disable linebreak-style
pragma solidity ^0.4.23;

contract RewardCalculator {

    function evaluate(uint8 rating, uint price, uint64 approvalTimestamp, uint64 offerTimestamp)
    external 
    pure 
    returns(uint rewardAmount) 
    {
        rewardAmount = rating * price; // This is preliminary.
    }
}