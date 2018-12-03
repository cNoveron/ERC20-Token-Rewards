// solium-disable linebreak-style
pragma solidity ^0.4.23;

contract RewardCalculator {

    function calculateRewardAmount(uint8 rating, uint64 price)
    external pure returns(uint RewardAmount) {
        RewardAmount = rating * price; // This is preliminary.
    }
}