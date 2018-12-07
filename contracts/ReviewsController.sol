// solium-disable linebreak-style
pragma solidity ^0.4.23;

import "./IServiceStateController.sol";
import "./RewardCalculator.sol";
import "./Pedro_ERC20Token.sol";

contract ReviewsController is IServiceStateController {
    
    RewardCalculator rewardCalculator;
    address currentRewardCalculator;

    Pedro_ERC20Token pedro_ERC20Token;
    address currentPedro_ERC20Token;
    
    constructor(address RewardCalculatorAddress, address Pedro_ERC20TokenAddress) 
    public {
        currentRewardCalculator = RewardCalculatorAddress;
        rewardCalculator = RewardCalculator(currentRewardCalculator);

        currentPedro_ERC20Token = Pedro_ERC20TokenAddress;
        pedro_ERC20Token = Pedro_ERC20Token(currentPedro_ERC20Token);
    }

    function setCurrentRewardCalculatorAddress(address RewardCalculatorAddress) 
    external {
        currentRewardCalculator = RewardCalculatorAddress;
        rewardCalculator = RewardCalculator(currentRewardCalculator);
    }

    function setCurrentPedro_ERC20TokenAddress(address Pedro_ERC20TokenAddress) 
    external {
        currentPedro_ERC20Token = Pedro_ERC20TokenAddress;
        pedro_ERC20Token = Pedro_ERC20Token(currentPedro_ERC20Token);
    }

    function requestServices(uint32 reviewId, uint64 requestTimestamp, uint32[] serviceIdArray)  
    external returns (bool) {
        require(is_reviewId_active[reviewId] == false);
            is_reviewId_active[reviewId] = true;
            get_serviceIdArray_from_reviewId[reviewId] = serviceIdArray;
            emit ServiceRequested(reviewId, requestTimestamp, serviceIdArray, msg.sender);
            return true;
        }

    mapping(uint32 => bool) is_reviewId_active;
    mapping(uint32 => uint32[]) get_serviceIdArray_from_reviewId;

    modifier validate_reviewId(uint32 reviewId) {
        require(is_reviewId_active[reviewId] == true);
        _;
    }

    function offerServices(uint32 reviewId, uint64 offerTimestamp, uint16 finalCustomersPrice) 
    external validate_reviewId(reviewId) returns (bool){
        get_finalCustomersPrice_from_reviewId[reviewId] = finalCustomersPrice;
        return true;
    }

    function acceptOffer(uint32 reviewId, uint64 acceptanceTimestamp, address offererEthAddress)
    external returns (bool){
        return;
    }

    function claimCompletion(uint32 reviewId, uint64 claimTimestamp)
    external returns (bool){

    }

    function approveCompletion(uint32 reviewId, uint64 approvalTimestamp, uint8 rank)
    external validate_reviewId(reviewId) returns (uint rewardAmount) {
        uint finalCustomersPrice = get_finalCustomersPrice_from_reviewId[reviewId];
        rewardAmount = rewardCalculator.calculateRewardAmount(rank, finalCustomersPrice);
    }

    mapping (uint32 => uint) get_finalCustomersPrice_from_reviewId;

    function rejectCompletion(uint32 reviewId, uint64 callTimestamp)
    external returns (bool){

    }
}